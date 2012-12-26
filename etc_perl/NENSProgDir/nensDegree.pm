# ............................ #
package nensDegree ;
{
    use Data::Dumper::Simple ;
    use lib qw(/etc/perl/NENSProgDir);
    use dbActions;
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
  my ( $this, $thisDegree, $csvpars ) = @_;
  my %properties =() ;
  $properties{'type'} = 'nens.Degree' ;
  $properties{'thisDegree'  } = $thisDegree  ;
  $properties{$properties{'type'}} = 'ID,Label,Category,Description' ;
  # .............................................
  %{$this} = %properties ;
  # .............................................
  print "\n-- IN :".$this->{'type'}.": --\n";
  $this->getDegree();
  if ( $this->{'emptySet'} eq 'yes' ) {
    $this->insertDegree() ;
    sleep 1 ;
    $this->getDegree();
    }
  undef ($this->{'lastQuery'}) if ( $this->{'emptySet'} eq 'no' );  
  $this;
  } # end sub ;
# ...................
sub getDegree {
  my ($this) = @_;
  # ................... The refering here:
  # ..$this->{'cttHash'}->{'thisDegree'} <- should be preset through
  # ..the calling nensOffersDegree object that devides the degree string
  # ..and reaches each degree through to this module to be handled 
  # ..separately.
  $this->{'lastQuery'}  = 'select '.$this->{'nens.Degree'}.' from Degree where ';
  $this->{'lastQuery'} .= '`Label`="'.$this->{'thisDegree'}.'";';
  # ...................
  my $myDB = new dbActions ('check',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}};
  $this->{'emptySet'}=$myDB->{'emptySet'};
  # print Dumper ($this->{'aSetThatExists'}) ;
  } # end sub ;
# ...................
sub insertDegree {
  my ($this) = @_;
  my ($fieldstr,$valstr) = ('','');
  # ................... The refering here:
  # ..$this->{'cttHash'}->{'thisDegree'} <- should be preset through
  # ..the calling nensOffersDegree object that devides the degree string
  # ..and reaches each degree through to this module to be handled
  # ..separately.
  $fieldstr .= 'insert into Degree ('.$this->{'nens.Degree'  }. ') ';
  $valstr   .= 'values ("", ';
  $valstr   .= '"'.$this->{'thisDegree'}.'", ';
  $valstr   .= 'NULL, ';
  $valstr   .= '"NULL" ';
  $this->{'lastQuery'} = $fieldstr.$valstr.');'  ;
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  # ...................
  } # end sub ;
}
# printf ("\n %s \n", $this->{'lastQuery'});

1; 

__END__
