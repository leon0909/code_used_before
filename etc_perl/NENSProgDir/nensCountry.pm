use Data::Dumper::Simple ;
use Geo::Query::LatLong;
use lib qw(/etc/perl/NENSProgDir);
use dbActions;
use strict;
no strict 'refs';


package nensCountry ;
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
  $properties{'type'} = 'nens.Country' ;
  $properties{'apikey'} = "ABQIAAAAPU7fv7U6Ax0WPiJM9KKwZBRCYSnFLLWEMMijz2uF-oJq8HsBthSFD5uSoftEjLWnEt_K81gVUIQcMg" ;
  $properties{'lastQuery'} = $lastQuery if ($lastQuery);
  $properties{'cttHash'  } = $cttHash   ;
  $properties{$properties{'type'}} = 'ID,Label,Coords,ISO' ;
  # .............................................
  %{$this} = %properties ;
  $this->{'csv2sqlMap'  } = $csvpars->csv2sqlMap();
  $this->{'mapSql2Csv'} = $csvpars->mapSql2Csv();
  # .............................................
  print "\n-- IN :".$this->{'type'}.": --\n";
  $this->getCountry();
  $this->insertCountry() if ( $this->{'emptySet'} eq 'yes' );  
  undef ($this->{'lastQuery'});
  $this;
  } # end sub ;
# ...................
sub getCountry {
  my ($this) = @_;
  # ...................
  undef ($this->{'lastQuery'});
  # ...................
  $this->{'lastQuery'}  = 'select '.$this->{'nens.Country'}.' from Country where ';
  $this->{'lastQuery'} .= '`Label`="'.$this->{'cttHash'}->{'Contact-Person-Country'}.'";';
  my $myDB = new dbActions ('check',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}};
  $this->{'emptySet'}=$myDB->{'emptySet'};
  # print Dumper ($this->{'aSetThatExists'}) ;
  } # end sub ;
# ...................
# printf ("\nkey1: /%s/ , - key2: /%s/ ,\n", $key, $this->{'csv2sqlMap'}->{$key});
# $this->{'mapSql2Csv'}->{$key}
# ...................
sub insertCountry {
  my ($this) = @_;
  my ($fieldstr,$valstr) = ('','');
  # ...................
  undef ($this->{'lastQuery'});
  # ...................
  $fieldstr .= 'insert into Country ('.$this->{'nens.Country'  }. ') ';
  $valstr   .= 'values ("", ';
  $valstr   .= '"'.$this->{'cttHash'}->{'Contact-Person-Country'}.'", ';
  $valstr   .= '"NULL", ';
  $valstr   .= '"NULL" ';
  
  $this->{'lastQuery'} = $fieldstr.$valstr.');'  ;
  # ...................
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  } # end sub ;
1; 
__END__
