
package nensLanguage ;
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
  my ( $this, $thisLanguage, $csvpars ) = @_;
  my %properties =() ;
  $properties{'type'} = 'nens.Language' ;
  $properties{'thisLanguage'  } = $thisLanguage  ;
  $properties{$properties{'type'}} = 'ID,Label' ;
  # .............................................
  %{$this} = %properties ;
  # .............................................
  print "\n-- IN :".$this->{'type'}.": --\n";
  $this->getLanguage();
  if ( $this->{'emptySet'} eq 'yes' ) {
    $this->insertLanguage() ;
    sleep 1 ;
    $this->getLanguage();
    }
  undef ($this->{'lastQuery'}) if ( $this->{'emptySet'} eq 'no' );  
  $this;
  } # end sub ;
# ...................
sub getLanguage {
  my ($this) = @_;
  # ................... The refering here:
  # ..$this->{'cttHash'}->{'thisLanguage'} <- should be preset through
  # ..the calling nensReqLanguage object that devides the language string
  # ..and reaches each language through to this module to be handled 
  # ..separately.
  $this->{'lastQuery'}  = 'select '.$this->{'nens.Language'}.' from Language where ';
  $this->{'lastQuery'} .= '`Label`="'.$this->{'thisLanguage'}.'";';
  # ...................
  my $myDB = new dbActions ('check',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}};
  $this->{'emptySet'}=$myDB->{'emptySet'};
  # print Dumper ($this->{'aSetThatExists'}) ;
  } # end sub ;
# ...................
sub insertLanguage {
  my ($this) = @_;
  my ($fieldstr,$valstr) = ('','');
  # ................... The refering here:
  # ..$this->{'cttHash'}->{'thisLanguage'} <- should be preset through
  # ..the calling nensReqLanguage object that devides the language string
  # ..and reaches each language through to this module to be handled
  # ..separately.
  $fieldstr .= 'insert into Language ('.$this->{'nens.Language'  }. ') ';
  $valstr   .= 'values ("", ';
  $valstr   .= '"'.$this->{'thisLanguage'}.'" ';
  $this->{'lastQuery'} = $fieldstr.$valstr.');'  ;
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  # ...................
  } # end sub ;
}
# printf ("\n %s \n", $this->{'lastQuery'});

1; 

__END__
