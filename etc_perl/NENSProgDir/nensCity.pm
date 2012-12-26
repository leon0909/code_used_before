use Data::Dumper::Simple ;
use Geo::Query::LatLong;
use lib qw(/etc/perl/NENSProgDir);
use dbActions;
use nensCountry;
use strict;
no strict 'refs';


package nensCity ;
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
  $properties{'type'} = 'nens.City' ;
  $properties{'apikey'} = "ABQIAAAAPU7fv7U6Ax0WPiJM9KKwZBRCYSnFLLWEMMijz2uF-oJq8HsBthSFD5uSoftEjLWnEt_K81gVUIQcMg" ;
  $properties{'lastQuery'} = $lastQuery if ($lastQuery);
  $properties{'cttHash'  } = $cttHash   ;
  $properties{$properties{'type'}} = 'ID,CountryID,Label,Coords' ;
  # .............................................
  %{$this} = %properties ;
  $this->{'csv2sqlMap'  } = $csvpars->csv2sqlMap();
  $this->{'mapSql2Csv'} = $csvpars->mapSql2Csv();
  # .............................................
  print "\n-- IN :".$this->{'type'}.": --\n";
  $this->getCity();
  # here we just reach the content hash further
  # to the Institution Object for it to update or to insert the Institution
  # data.
  $this->{'country'} = new nensCountry($this->{'cttHash'}, $csvpars);
  #print Dumper($this->{'country'});
  #exit;
  $this->{'aSetThatExists'}->{'CountryID'} = $this->{'country'}->{'aSetThatExists'}->{'ID'} ;
  $this->{'cttHash'}->{'Contact-Person-Country'} = $this->{'country'}->{'aSetThatExists'}->{'ID'} ;
  $this->getCityCoordinates(
    $this->{'aSetThatExists'}->{'Label'},
    $this->{'country'}->{'aSetThatExists'}->{'ISO'},
    );
  ( $this->{'emptySet'} eq 'no' ) ? $this->updateCity() : $this->insertCity() ;  
  undef ($this->{'lastQuery'}) ;
  $this;
  } # end sub ;
sub getCityCoordinates {
  my ($this, $city, $countryISO) = @_;
  my $geo = Geo::Query::LatLong->new( source => 'Google', apikey => $this->{'apikey'} );
  my $res = $geo->query( city => $city, country_code => $countryISO ); # FIPS 10 country code
  $this->{'lat'} = $res->{'lat'};
  $this->{'lng'} = $res->{'lng'};
  $this->{'Coords'} = $res->{'lat'}.",".$res->{'lng'}.",0";
  }
# ...................
sub getCity {
  my ($this) = @_;
  # ...................
  undef ($this->{'lastQuery'}) ;
  # ...................
  $this->{'lastQuery'}  = 'select '.$this->{'nens.City'}.' from City where ';
  $this->{'lastQuery'} .= '`Label`="'.$this->{'cttHash'}->{'Contact-Person City'}.'";';
  my $myDB = new dbActions ('check',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}};
  $this->{'emptySet'}=$myDB->{'emptySet'};
  #print Dumper ($this->{'aSetThatExists'}) ;
  } # end sub ;
# ...................
sub updateCity {
  # ...................
  my ($this) = @_;
  # ...................
  undef ($this->{'lastQuery'}) ;
  # ...................
  if ( $this->{'aSetThatExists'}->{'Coords'} eq 'Null' ) {
    $this->{'lastQuery'} = 'update City set Coords="'.$this->{'Coords'}.'" where ID='.$this->{'aSetThatExists'}->{'ID'}.'; ';
    }
  else {
    undef $this->{'lastQuery'} ;
    }
  } # end sub ;
#printf (" %s \n", $this->{'lastQuery'});
# ...................
# printf ("\nkey1: /%s/ , - key2: /%s/ ,\n", $key, $this->{'csv2sqlMap'}->{$key});
# $this->{'mapSql2Csv'}->{$key}
# ...................
sub insertCity {
  my ($this) = @_;
  my ($fieldstr,$valstr) = ('','');
  # .........................
  undef ($this->{'lastQuery'}) ;
  # .........................
  $this->{Coords} = '' if ( $this->{Coords} =~ /99\,99\,0/ );
  $fieldstr .= 'insert into City ('.$this->{'nens.City'  }. ') ';
  $valstr   .= 'values ("", "'.$this->{'country'}->{'aSetThatExists'}->{'ID' }.'", ';
  $valstr   .= '"'.$this->{'cttHash'}->{'Contact-Person City'}.'", ';
  $valstr   .= '"'.$this->{Coords}.'" ';
  
  $this->{'lastQuery'} = $fieldstr.$valstr.');'  ;
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  } # end sub ;
# printf (" %s \n", $this->{'lastQuery'});

1; 

__END__
