#
##
##
##
#
package nensReqLanguage ;
{
    use Data::Dumper::Simple ;
    use lib qw(/etc/perl/NENSProgDir);
    use dbActions;
    use nensLanguage;
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
  my ( $this, $cttHash, $csvpars, $lastQuery ) = @_;
  my %properties =() ;
  # .............................
  $properties{'type'} = 'nens.requiresLanguage' ;
  # .............................
  ( # ...................
    $properties{'typeDB'}, 
    $properties{'typeTable'} 
    # ...................
    ) = $properties{'type'} =~ /^(.*?)\.(.*)/;
  $properties{'lastQuery'} = $lastQuery if ($lastQuery);
  $properties{'cttHash'  } = $cttHash   ;
  $properties{$properties{'type'}} = 'CourseID,LanguageID,Priority' ;
  # .............................................
  %{$this} = %properties ;
  $this->{'csv2sqlMap'  } = $csvpars->csv2sqlMap();
  $this->{'mapSql2Csv'} = $csvpars->mapSql2Csv();
  #$this->{'typeFields'} = 
  # .............................................
  print "\n-- IN :".$this->{'type'}.": --\n";
  # in this object we handle the udate/insert procedures 
  # inside the getReqLanguage function
  $this->getReqLanguage($csvpars);
  # here we just reach the content hash further
  # to the Institution Object for it to update or to insert the Institution
  # data.
  $this;
  } # end sub ;
# ...................
sub getReqLanguage {
  my ($this, $csvpars) = @_;
  # ...................
  # 1. parse $this->{'cttHash'}->{'Program language'} value
  # and extract each Language picing them out from a 
  # comma separated string
  #
  my @langs = split (',',$this->{'cttHash'}->{'Program language'}) ;
  # ...................
  # 2. call the nensLanguage object to get sure that every Language is
  # already present in the nens.Languages table
  #
  foreach (@langs) {
    $this->{'last'} = $_ ; 
    $this->{'last'} =~ s/^\s+//;
    $this->{'last'} =~ s/\s+$//;
    $this->{$this->{'last'}} = new nensLanguage($this->{last},$csvpars);
    $this->{'aSetThatExists'}->{'IDsCombined'}    .= $this->{$this->{'last'}}->{'aSetThatExists'}->{'ID'}.',' ;
    $this->{'aSetThatExists'}->{'labelsCombined'} .= $this->{$this->{'last'}}->{'aSetThatExists'}->{'Label'}.',' ;
    $this->{languages}->{ $this->{'last'} } = $this->{$this->{'last'}}->{'aSetThatExists'}->{'ID'};
    }
  # ...................
  # removing the last semicolon from the combined string:  
  $this->{'aSetThatExists'}->{'IDsCombined'} =~ s/\,$//;
  $this->{'aSetThatExists'}->{'labelsCombined'}  =~ s/\,$//;
  # ...................
  # 3. Now we are sure to have every new Language in the Language Database Table
  # We could try to update the reqiuresLanguage table now, but much quicker
  # 
  #  print Dumper ($this);
  
  $this->{'lastQuery'}  = 'delete from  '.$this->{'typeTable'}.' where `CourseID`="'.$this->{'cttHash'}->{'1D'}.'" ;';
  my $myDB = new dbActions ('delete',$this->{'lastQuery'},$this->{'type'}) ;
  undef $this->{'lastQuery'} ;
  # ............................
  $this->insertReqLanguage();
  } # end sub ;
# printf ( "\n %s\n", $this->{'lastQuery'});
# ...................
sub makeValstr {
  my ($this, $langID, $pri) = @_;
  my $valstr    = 'values ("'.$this->{'cttHash'}->{'1D'}.'", "';
  $valstr   .=  $langID.'", '.$pri.' );';
  } # end sub ;
# ...................
sub insertReqLanguage {
  my ($this) = @_;
  my %langs = %{$this->{'languages'}};
  my $pri = 0;
  foreach my $key (keys %langs) {
    undef $this->{'lastQuery'} ;
    my $fieldstr  = 'insert into '.$this->{'typeTable'}.' ('.$this->{'nens.requiresLanguage'  }. ') ';
    my $valstr    = $this->makeValstr($langs{$key},$pri);
    $this->{'lastQuery'} = $fieldstr.$valstr ;
    my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
    $pri ++;
    }
  undef $this->{'lastQuery'};
  undef $pri;
  } # end sub ;
# printf ("\n %s \n", $this->{'lastQuery'});
}

1; 

__END__
