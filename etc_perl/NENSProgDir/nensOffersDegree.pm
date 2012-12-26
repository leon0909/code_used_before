#
##
##
##
#
package nensOffersDegree ;
{
    use Data::Dumper::Simple ;
    use lib qw(/etc/perl/NENSProgDir);
    use dbActions;
    use nensDegree;
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
  $properties{'type'} = 'nens.offersDegree' ;
  # .............................
  ( # ...................
    $properties{'typeDB'}, 
    $properties{'typeTable'} 
    # ...................
    ) = $properties{'type'} =~ /^(.*?)\.(.*)/;
  $properties{'lastQuery'} = $lastQuery if ($lastQuery);
  $properties{'cttHash'  } = $cttHash   ;
  $properties{$properties{'type'}} = 'CourseID,DegreeID,Priority' ;
  # 
  %{$this} = %properties ;
  $this->{'csv2sqlMap'  } = $csvpars->csv2sqlMap();
  $this->{'mapSql2Csv'} = $csvpars->mapSql2Csv();
  #$this->{'typeFields'} = 
  # .............................................
  print "\n-- IN :".$this->{'type'}.": --\n";
  # in this object we handle the udate/insert procedures 
  # inside the getOffersDegree function
  $this->getOffersDegree($csvpars);
  # here we just reach the content hash further
  # to the Institution Object for it to update or to insert the Institution
  # data.
  $this;
  } # end sub ;
# ...................
sub getOffersDegree {
  my ($this, $csvpars) = @_;
  # ...................
  # 1. parse $this->{'cttHash'}->{'Program language'} value
  # and extract each Degree picing them out from a 
  # comma separated string
  #
  my @degrees = split (',',$this->{'cttHash'}->{'Degree(s) available'}) ;
  # ...................
  # 2. call the nensDegree object to get sure that every Degree is
  # already present in the nens.Degrees table
  #
  foreach (@degrees) {
    $this->{'last'} = $_ ; 
    $this->{'last'} =~ s/^\s+//;
    $this->{'last'} =~ s/\s+$//;
    $this->{$this->{'last'}} = new nensDegree($this->{last},$csvpars);
    $this->{'aSetThatExists'}->{'IDsCombined'}    .= $this->{$this->{'last'}}->{'aSetThatExists'}->{'ID'}.',' ;
    $this->{'aSetThatExists'}->{'labelsCombined'} .= $this->{$this->{'last'}}->{'aSetThatExists'}->{'Label'}.',' ;
    $this->{availableDegrees}->{ $this->{'last'} } = $this->{$this->{'last'}}->{'aSetThatExists'}->{'ID'};
    }
  # ...................
  # removing the last semicolon from the combined string:  
  $this->{'aSetThatExists'}->{'IDsCombined'} =~ s/\,$//;
  $this->{'aSetThatExists'}->{'labelsCombined'}  =~ s/\,$//;
  # ...................
  # 3. Now we are sure to have every new Degree in the Degree Database Table
  # We could try to update the offersDegree table now, but it is much quicker
  # just to delete old values and incert the new ones
  #
  $this->{'lastQuery'}  = 'delete from  '.$this->{'typeTable'}.' where `CourseID`="'.$this->{'cttHash'}->{'1D'}.'" ;';
  my $myDB = new dbActions ('delete',$this->{'lastQuery'},$this->{'type'}) ;
  undef $this->{'lastQuery'} ;
  # ............................
  $this->insertOffersDegree();
  } # end sub ;
# printf ( "\n %s\n", $this->{'lastQuery'});
# ...................
sub makeValstr {
  my ($this, $langID, $pri) = @_;
  my $valstr    = 'values ("'.$this->{'cttHash'}->{'1D'}.'", "';
  $valstr   .=  $langID.'", '.$pri.' );';
  } # end sub ;
# ...................
sub insertOffersDegree {
  my ($this) = @_;
  my %degrs = %{$this->{'availableDegrees'}};
  my $pri = 0;
  foreach my $key (keys %degrs) {
    # ..........................
    undef $this->{'lastQuery'};
    my $fieldstr  = 'insert into '.$this->{'typeTable'}.' ('.$this->{'nens.offersDegree'  }. ') ';
    my $valstr    = $this->makeValstr($degrs{$key},$pri);
    undef $this->{'lastQuery'};
    $this->{'lastQuery'} = $fieldstr.$valstr ;
    my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
    $pri ++;
    }
  undef $pri;
  undef $this->{'lastQuery'};
  } # end sub ;
}
# printf ("\n %s \n", $this->{'lastQuery'});

1; 

__END__
