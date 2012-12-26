#
##
##
#

package nensCourse ;
{
    use Data::Dumper::Simple ;
    use lib qw(/etc/perl/NENSProgDir);
    use base ('csvParse');
    use dbActions;
    use nensOffersDegree;
    use nensReqLanguage;
    use nensTakesPlaceAt;
    use strict;
    no strict 'refs';

sub new {
  # .............................................
  my $selfName = shift;
  my $this     =    {};
  # .. Referenz auf anonymen hash ;
  bless($this, $selfName);
  $this->_init(@_);
  return $this;
  } # end sub ;
# ...................
sub _init {
  # .............................
  my ( $this, $cttHash, $csvpars, $OwnerID ) = @_;
  my %properties =() ;
  $properties{'type'} = 'nens.Course' ;
  $properties{'cttHash'  } = $cttHash   ;
  # .............................................
  %{$this} = %properties ;
  $this->{'csv2sqlMap'  } = $csvpars->csv2sqlMap();
  $this->{'mapSql2Csv'} = $csvpars->mapSql2Csv();
  $this->{'OwnerID'} = $OwnerID ;
  # ............FOREIGHN KEYS: ..................
  # OwnerID:
  #   -> table Course
  # .............................................
  ## The following Foreign Keys are programmatically implemented through
  ## PHP code of the NENS webpage and not through the SQL table Relations.
  ## Still their field values should be updated accordingly, - as the
  ## new data that we gat from the Excel/csv file contains eventually new
  ## data for their fields.
  # ...........
  # LanguageID: 
  #   ->table Language (1:1) and 
  #   ->table requiresLanguage (1:Multiple)
  # DegreeID:
  #   -> table Degree
  # ...........
  $this->{'foreignKeys'} = "OwnerID,LanguageID,DegreeID";
  # .............................................
  print "\n -- IN :".$this->{'type'}.": --\n";
  $this->getType();
  # .............................................
  $this->{'typeFields'}->{'OwnerID'}      = $this->{'OwnerID'} ;
  $this->{'typeFields'}->{'LanguageIDs'}  = 'getsSetTrhoughCallBack';
  $this->{'typeFields'}->{'DegreeIDs'}    = 'getsSetTrhoughCallBack';
  #...........
  # 'Duration of the program'      => 'Course:Duration', #/* See Course Fields */
  # 'Program language'             => 'Language:Label', #/* tables requiresLanguage and over its foreign key - Language  */
  # 'Degree(s) available'          => 'Degree:Label',
  # .............................................
  # first of all we handle the Foreign Keys Data :
  # .................................
  # we just reach the content hash further 
  # to another Fieldname Object for it to update or to insert 
  # the needed Foreign Key data.
  # .................................
  # the OffersDegree Object 
  $this->{'typeFields'}->{'DegreeIDs'} = 
  my $degrees = new nensOffersDegree ($this->{'cttHash'}, $csvpars);
      # ..! -Combined fields are to be implemented inside the nensOffersDegree - Object !.. ;
      $this->{'typeFields'}->{'DegreeIDs'} = $degrees->{'aSetThatExists'}->{'IDsCombined'} ;
      $this->{'cttHash'}->{'Degree(s) available'} = $degrees->{'aSetThatExists'}->{'labelsCombined'} ;
      #  $this->{'aSetThatExists'}->{'DegreesID'} - doesn't need to be set because the
      #  table Course doesn't have it as an SQL Relation Foreign Key, but it really is one
      #  because of the programmatical php implementation of its contents through the 
      # "select box (type multiple)" php/html construct.
  # .................................
  #  the RequiresLanguage Object
  my $langs = new nensReqLanguage ($this->{'cttHash'}, $csvpars);
      $this->{'typeFields'}->{'LanguageIDs'} = $langs->{'aSetThatExists'}->{'IDsCombined'} ;
      $this->{'cttHash'}->{'Program language'} = $langs->{'aSetThatExists'}->{'labelsCombined'} ;
      #  $this->{'aSetThatExists'}->{'LanguageIDs'} - doesn't need to be set because the
      #  table Course doesn't have it as an SQL Relation Foreign Key, but it really is one
      #  because of the programmatical php implementation of its contents through the 
      # "select box (type multiple)" php/html construct.
  # .................................
  #  the RequiresLanguage Object
  my $langs = new nensTakesPlaceAt ($this->{'cttHash'}, $csvpars);
      # the called object should handle the takesPlaceAt
      # and the Institution tables.
  # .................................
  #  now we get the data for this object:
  # .............................................  
  $this->getCourse();
  # .................................
  $this->{'typeFields'}->{'OwnerID'} = $this->{'aSetThatExists'}->{'OwnerID'} 
    if ($this->{'aSetThatExists'}->{'OwnerID'});
  # .................................
  # $this->{'typeFields'}->{'ID'}       = $this->{'cttHash'}->{'1D'} 
  #  if ($this->{'aSetThatExists'}->{'ID'} eq $this->{'cttHash'}->{'1D'});
  ( $this->{'emptySet'} eq 'no' ) ? $this->updateCourse() : $this->insertCourse() ;  
  # ...................
  $this;
  } # end sub ;
# ...................
sub getType {
  my ($this) = @_;
  # ...............................
  ($this->{'db'},$this->{'table'}) = $this->{'type'} =~ /(.*?)\.(.*)/;
  # ...............................
  foreach my $key ( sort (keys %{$this->{'mapSql2Csv'}})) {
    if ($key =~ /$this->{'table'}/) { 
      ($this->{'tmp1'},$this->{'tmp2'}) = $key =~ /(.*?)\:(.*)/;
      $this->{ $this->{'type'} } .= $this->{'tmp2'}.',';
      $this->{'typeFields'}->{$this->{'tmp2'}} = $this->{'mapSql2Csv'}->{$key};
      }
    $this->{ $this->{'type'} } .= 'Created, ' ;
    $this->{'typeFields'}->{'Created'} = '';
    $this->{ $this->{'type'} } .= 'Modified ' ;
    $this->{'typeFields'}->{'Modified'} = '';
    }
  # ...............................
  $this->{ $this->{'type'} } .= $this->{'foreignKeys'} ;  
  $this->{'fieldsTypes'}->{$this->{'typeFields'}->{$_}} = $_ for keys %{$this->{'typeFields'}};
  } # end sub ;
# ...................
sub getCourse {
  my ($this) = @_;
  $this->{'lastQuery'}  = 'select * from Course where ';
  $this->{'lastQuery'} .= 'ID='.$this->{'cttHash'}->{'1D'}.';';
  my $myDB = new dbActions ('check',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}};
  $this->{'emptySet'}=$myDB->{'emptySet'};
  #print Dumper ($this->{'aSetThatExists'});
  } # end sub ;
# ...................
sub updateCourse {
  # ...................
  my ($this) = @_;
  # ...................
  my $out = '' ;
  # ...................
  foreach my $key (keys %{$this->{'cttHash'}}) {
    next unless ($this->{'aSetThatExists'}->{ $this->{'fieldsTypes'}->{$key} }) ;
    #printf ("\nkey: %s \n feld: %s", $key, $this->{'fieldsTypes'}->{$key} );
    $out .= $this->{'fieldsTypes'}->{$key}.'="'.$this->{'cttHash'}->{$key}.'", '
      if ($this->{'aSetThatExists'}->{$this->{'fieldsTypes'}->{$key}} ne $this->{'cttHash'}->{$key});
    }
  chop $out;  
  chop $out;  
  ( $out ne '' ) 
    ?  $this->{'lastQuery'} = 'update Course set '.$out.' where ID='.$this->{'cttHash'}->{'1D'}.'; '
    :  undef $this->{'lastQuery'} ;
  } # end sub ;
# printf ("\n %s \n", $this->{'lastQuery'});
# ...................
sub insertCourse {
  my ($this) = @_;
  my ($fieldstr,$valstr) = ('','');
  my $timestemp = time() ;
  $fieldstr .= 'insert into Course ( ID, OwnerID, Created, Modified, Status, ';
  $valstr   .= ' ) values ('.$this->{'cttHash'}->{'1D'}.', ';
  $valstr   .= $this->{'OwnerID'}.', ';
  $valstr   .= $timestemp.', ';
  $valstr   .= $timestemp .', ';
  $valstr   .= '1, "';
  
  foreach my $key (keys %{$this->{'csv2sqlMap'}}) {
    next if ( $this->{'csv2sqlMap'}->{$key} =~ /nens\./) ;
    my ($field, $rest) = $this->{'csv2sqlMap'}->{$key} =~ /^Course:(\w+?)$/;
    next unless ($field ne '') ;
    next if ($field eq 'ID') ;
    $fieldstr .= $field.', ';
    $valstr   .= $this->{'cttHash'}->{$key}.'", "';
    }

  chop $fieldstr;  
  chop $fieldstr;  
  chop $valstr;  
  chop $valstr;  
  chop $valstr;  
  $this->{'lastQuery'} = $fieldstr.$valstr.');'  ;
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  } # end sub ;
}
#  printf ("\n %s \n", $this->{'lastQuery'});

1; 

__END__
