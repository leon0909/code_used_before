#
##
##
#

package nensContact ;
{
    use Data::Dumper::Simple ;
    use lib qw(/etc/perl/NENSProgDir);
    use base ('csvParse');
    use dbActions;
    use nensCity;
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
  my ( $this, $cttHash, $csvpars ) = @_;
  my %properties =() ;
  $properties{'type'} = 'nens.Contact' ;
  $properties{'cttHash'  } = $cttHash   ;
  # .............................................
  %{$this} = %properties ;
  $this->{'csv2sqlMap'  } = $csvpars->csv2sqlMap();
  $this->{'mapSql2Csv'} = $csvpars->mapSql2Csv();
  # .............................................
  $this->{'foreignKeys'} = "CourseID,CityID,InstitutionID";
  print "\n-- IN :".$this->{'type'}.": --\n";
  $this->getType();
  # .............................................
  $this->{'typeFields'}->{'CourseID'}      = 'getsSetTrhoughCallBack';
  $this->{'typeFields'}->{'CityID'}        = 'getsSetTrhoughCallBack';
  $this->{'typeFields'}->{'InstitutionID'} = 'getsSetTrhoughCallBack';
  # .............................................
  $this->getContact();
  # .................................
  $this->{'typeFields'}->{'CourseID'} = $this->{'aSetThatExists'}->{'CourseID'} 
    if ($this->{'aSetThatExists'}->{'CourseID'});
  # .................................
  $this->{'typeFields'}->{'ID'}       = $this->{'aSetThatExists'}->{'ID'} 
    if ($this->{'aSetThatExists'}->{'ID'});
  # .................................
  # we just reach the content hash further 
  # to another Fieldname Object for it to update or to insert 
  # the needed Foreign Key data.
  # .................................
  # the City Object 
  my $city = new nensCity($this->{'cttHash'},$csvpars);
      $this->{'typeFields'}->{'CityID'} = $city->{'aSetThatExists'}->{'ID'} ;
      $this->{'aSetThatExists'}->{'CityID'} = $city->{'aSetThatExists'}->{'ID'} ;
      $this->{'cttHash'}->{'Contact-Person City'} = $city->{'aSetThatExists'}->{'ID'} ;
      $this->{'aSetThatExists'}->{'CountryID'} = $city->{'aSetThatExists'}->{'CountryID'} ;
      $this->{'cttHash'}->{'Contact-Person-Country'} = $city->{'aSetThatExists'}->{'CountryID'} ;
  # .................................
  #  the Institution Object
  my $institution = new nensTakesPlaceAt($this->{'cttHash'},$csvpars);
      $this->{'typeFields'}->{'InstitutionID'} 
        = $institution->{'contactInstitution'}->{'aSetThatExists'}->{'ID'} ;
      $this->{'cttHash'}->{'InstitutionID'} = $institution->{'aSetThatExists'}->{'ID'} ;
      $this->{'aSetThatExists'}->{'InstitutionID'} = $institution->{'aSetThatExists'}->{'ID'} ;
  # .............................................  
  #print "\n Fields :/".Dumper($this->{'typeFields'})."/:\n";
  #print "\n Types :/".Dumper($this->{'fieldsTypes'})."/:\n";
  # .............................................  
  $this->getContact();

  $this->{'ContactID'} = $this->{'aSetThatExists'}->{'ID'};
  # ...................
  ( $this->{'emptySet'} eq 'no' ) ? $this->updateContact() : $this->insertContact() ;  
  # ...................
  sleep 2 ;
  $this->getContact();
  print Dumper ($this);
  } # end sub ;
# ...................
sub getType {
  my ($this) = @_;
  ($this->{'db'},$this->{'table'}) = $this->{'type'} =~ /(.*?)\.(.*)/;
  foreach my $key ( sort (keys %{$this->{'mapSql2Csv'}})) {
    if ($key =~ /$this->{'table'}/) { 
      ($this->{'tmp1'},$this->{'tmp2'}) = $key =~ /(.*?)\:(.*)/;
      $this->{ $this->{'type'} } .= $this->{'tmp2'}.',';
      $this->{'typeFields'}->{$this->{'tmp2'}} = $this->{'mapSql2Csv'}->{$key};
      }
    }
  $this->{ $this->{'type'} } .= $this->{'foreignKeys'}.',ID' ;  
  $this->{'fieldsTypes'}->{$this->{'typeFields'}->{$_}} = $_ for keys %{$this->{'typeFields'}};
  } # end sub ;
# ...................
sub getContact {
  my ($this) = @_;
  $this->{'lastQuery'}  = 'select * from Contact where ';
  $this->{'lastQuery'} .= 'CourseID='.$this->{'cttHash'}->{'1D'}.';';
  print "\n Query :/".Dumper($this->{'lastQuery'})."/:\n";
  my $myDB = new dbActions ('check',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}};
  $this->{'emptySet'}=$myDB->{'emptySet'};
  } # end sub ;
# ...................
sub updateContact {
  # ...................
  my ($this) = @_;
  # ...................
  my $out = '' ;
  # ...................
  foreach my $key (keys %{$this->{'cttHash'}}) {
    next unless ($this->{'aSetThatExists'}->{ $this->{'fieldsTypes'}->{$key} }) ;
    printf ("\nkey: %s \n feld: %s", $key, $this->{'fieldsTypes'}->{$key} );
    $out .= $this->{'fieldsTypes'}->{$key}.'="'.$this->{'cttHash'}->{$key}.'", '
      if ($this->{'aSetThatExists'}->{$this->{'fieldsTypes'}->{$key}} ne $this->{'cttHash'}->{$key});
    }
  chop $out;  
  chop $out;  
  ( $out ne '' ) 
    ?  $this->{'lastQuery'} = 'update Contact set '.$out.' where CourseID='.$this->{'cttHash'}->{'1D'}.'; '
    :  undef $this->{'lastQuery'} ;
  } # end sub ;
#  printf (" %s \n", $this->{'lastQuery'});
# ...................
# printf ("\nkey1: /%s/ , - key2: /%s/ ,\n", $key, $this->{'csv2sqlMap'}->{$key});
# $this->{'mapSql2Csv'}->{$key}
# ...................
sub insertContact {
  my ($this) = @_;
  my ($fieldstr,$valstr) = ('','');
  $fieldstr .= 'insert into Contact (ID, CourseID, InstitutionID, CityID, Priority, Label,';
  $valstr   .= ') values ("", '.$this->{'cttHash'}->{'1D'}.', ';
  $valstr   .= $this->{'typeFields'}->{'InstitutionID'}.', ';
  $valstr   .= $this->{'typeFields'}->{'CityID'}.', ';
  $valstr   .= '1, "Administration Contact", "';
  
  foreach my $key (keys %{$this->{'csv2sqlMap'}}) {
    next if ( $this->{'csv2sqlMap'}->{$key} =~ /nens\./) ;
    my ($field, $rest) = $this->{'csv2sqlMap'}->{$key} =~ /^Contact:(\w+?)$/;
    # printf (" field:%s rest: %s \n", $field, $rest);
    next unless ($field ne '') ;
    $fieldstr .= $field.', ';
    $this->{'cttHash'}->{$key} =~ s/\s+$//;
    $this->{'cttHash'}->{$key} =~ s/^\s+//;
    $valstr   .= $this->{'cttHash'}->{$key}.'", "';
    }
  chop $fieldstr;  
  chop $fieldstr;  
  chop $valstr;  
  chop $valstr;  
  chop $valstr;  
  $this->{'lastQuery'} = $fieldstr.$valstr.');'  ;
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  sleep 1;
  } # end sub ;
}

1; 

__END__
