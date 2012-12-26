# ............................ #
package nensInstitution ;
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
  my ( $this, $thisInstHashRef, $csvpars ) = @_;
  my %instHashRef = %{$thisInstHashRef} ;
  my %properties =() ;
  $properties{'type'} = 'nens.Institution' ;
  $properties{'thisInstitution' } = $instHashRef{'Institution'} ;
  $properties{'thisDepartment'  } = $instHashRef{'Department' } ;
  $properties{$properties{'type'}} = 'ID,Label,Department' ;
  # .............................................
  %{$this} = %properties ;
  # .............................................
  print "\n -- IN :".$this->{'type'}.": -- \n";
  $this->getInstitution();
  if ( $this->{'emptySet'} eq 'yes' ) {
    $this->insertInstitution() ;
    sleep 1 ;
    $this->getInstitution();
    }
  undef ($this->{'lastQuery'}) if ( $this->{'emptySet'} eq 'no' );  
  $this;
  } # end sub ;
# ...................
sub getInstitution {
  my ($this) = @_;
  # ................... The refering here:
  # ..the calling nensTakesPlaceAt object that devides the institution string
  # ..and reaches each institution through to this module to be handled 
  # ..separately.
  $this->{'lastQuery'}  = 'select '.$this->{'nens.Institution'}.' from Institution where ';
  my ($first, $Department ) = $this->{'thisInstitution'} =~  /^(.*?)([\,|\(.]\s*.*)$/i ;
  $first =~ s/\s+$//;
  $Department =~ s/\s+$//;
  if ($first eq '' or $first =~ /Dep/) {
    $first = $this->{'thisInstitution'};
    $first =~ s/\s+$//;
    $Department = '';
    $this->{'lastQuery'} .= '`Label`="'.$first.'";';
    }
  
  else {  
    # ...................
    $this->{'lastQuery'} .= '`Label` LIKE "%'.$first.'%";';
    if ($Department ne '' ) {
      chop($this->{'lastQuery'});
      $this->{'lastQuery'} .= ' and Department LIKE "%'.$Department.'%";';
      }
    }
  # ...................
  my $myDB = new dbActions ('check',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}};
  $this->{'emptySet'}=$myDB->{'emptySet'};
  # print Dumper ($this->{'aSetThatExists'}) ;
  } # end sub ;
# ...................
sub insertInstitution {
  my ($this) = @_;
  my ($fieldstr,$valstr) = ('','');
  # ................... The refering here:
  # ..the calling nensTakesPlaceAt object that devides the institution string
  # ..and reaches each institution through to this module to be handled
  # ..separately.
  $fieldstr .= 'insert into Institution ('.$this->{'nens.Institution'  }. ') ';
  $valstr   .= 'values ("", ';
  $valstr   .= '"'.$this->{'thisInstitution'}.'", ';
  $valstr   .= '"'.$this->{'thisDepartment'}.'" ';
  $this->{'lastQuery'} = $fieldstr.$valstr.');'  ;
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  # ...................
  } # end sub ;
}

1; 

__END__
