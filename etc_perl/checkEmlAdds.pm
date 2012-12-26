#!/usr/bin/perl -w

use Data::Dumper::Simple ;
use DBI;
use strict;
no strict 'refs';


package checkEmlAdds ;
sub new {
  # ......................................................
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
  my ( $this, $Society ) = @_;
  # ...................
  my %properties =() ;
  $properties{'society'} =  $Society if ($Society ne '') ;
  $properties{'dbName'} = 'realDBname'    ;
  $properties{'host'  } = '127.0.0.1' ;
  $properties{'user'  } = 'realDBname'    ;
  $properties{'tName' } = 'Member'    ;
  $properties{'tmpSQLfile'} = "/tmp/checkEmlAdds.sql";
  $properties{'getNoEmails' } = '/usr/local/admin/fetch_noemails';
  # .............................................
  %{$this} = %properties ;
  # .............................................
  $this->getAllSocieties () ;
  $this->setCountryISOS ();
  $this->createLists();
  if ($this->{'society'}) {
    $this->printList($this->{'society'});
    }
  else {
    $this->printList() ;
    }
  # ........................................
  }

sub getAllSocieties {
  my ( $this ) = @_;
   $this->{'lastBashCmd'} = $this->{'getNoEmails'};
   # debug: print "\n".$this->{'lastBashCmd'}."\n";
   open(
    F, $this->{'lastBashCmd' }." |"
    );
   # ...................
   my $line='';
   while (defined($line = <F>)) {
    chomp($line) ;
    next if ($line eq '') ;
    $line =~ /(.*):(.*)/ ;
    $this->{'Societies'}{$1} = $2;
    }
    close (F) ;
  } # end sub;
# ...................
sub getNoEmailUserData {
  my ( $this, $Society ) = @_;
  # ...................
  die ('no Society was provided as an Argument! Aborting!'.$!) unless ($Society);
  $this->{'Society'} = $Society;
  # ...................
  $this->{'lastQuery'}  = 'SELECT concat_ws("-",SocietyID,ID) as UniqID,SocietyID,ID,Phone,Fax,FirstName,Name,Status,MemberSince,';
  $this->{'lastQuery'} .= 'Institution,Street,ZipCode,City,Country,country_iso ';
  $this->{'lastQuery'} .= "FROM Member WHERE (email='' and SocietyID='".$this->{'Society'}."' and Status='valid')";
  $this->{'lastQuery'} .= " OR (email='NONE' and SocietyID='".$this->{'Society'}."' and Status='valid') ORDER BY SocietyID;";
  # ...................
  my $dsn  = "DBI:mysql:database=".$this->{'dbName'}.";"; 
  my $dbh = DBI->connect  ( 
    $dsn, 
    $this->{'user'}, 
    '', 
    {'RaiseError' => 1} 
    );
  my $drh = DBI->install_driver("mysql");
  my $sth = $dbh->prepare($this->{'lastQuery'});
  # print Dumper ($this->{'lastQuery'})."\n" ;
  $sth->execute or $this->getSQLError(
    $sth->errstr,
    $this->{'lastQuery'},
    '1') ;
  $this->{'key_field'} = 'UniqID' ;
  $this->{'noEmailMembers'} = $sth->fetchall_hashref( $this->{'key_field'} );
  my %uHsh=%{$this->{'noEmailMembers'}};
  $this->{'numRows'} = $sth->rows;
  # ........................................
  } # end sub;
# ...................
sub getFormat {
  my ($this) = @_ ;
  # ........................................
  foreach my $member ( # ...
    keys ( # ...
    %{$this->{'noEmailMembers'} }
        )
      )   { # ...
    foreach my $infField ( # ...
      keys ( # ...
      %{ $this->{'noEmailMembers'}->{$member} } 
          ) 
        )   { # ...
      $this->{'format'} .= uc ($infField);
      $this->{'format'} .= ': %';
      $this->{'format'} .= $infField;
      $this->{'format'} .= ' ';
      }
    last;
    }
  $this->{'format_unordered'} = $this->{'format'}."\n";
  $this->{'format'}  = "\n";
  $this->{'format'} .= '';
  $this->{'format'} .= '%FirstName %Name , %SocietyID - %Status member, ';
  $this->{'format'} .= ' %Institution , %Street , %City , %ZipCode , %Country / %country_iso , ';
  $this->{'format'} .= "telephone: %Phone  \n";
  } # end sub;  
# ...................
sub printFormat {
  my ($this,$formstr,$refSimplHash) = @_ ;
  my %data = %{$refSimplHash};
  my $outstr=$formstr;
  # ........................................
  foreach my $dtKey (keys %data) {
    my $val = $data{$dtKey}; 
    if ($dtKey eq 'country_iso' ){
      $val = $this->{'ISO'}->{ $data{'Country'} } ;
      }
    if (($val eq '') or ($val eq '0')) {
      $outstr =~ s/\,\s+telephone:\s+\%$dtKey//g ; 
      $outstr =~ s/\,\s+\%$dtKey//g ; 
      $outstr =~ s/\s+\%$dtKey//g ; 
      }
    else {  
      $outstr =~ s/\%$dtKey/$val/g ; 
      }
    }
  $outstr;  
  } # end sub;  
# ...................
sub createLists {
  my ($this) = @_ ;
  # ........................................
  foreach my $society ( # ...
    keys ( # ...
    %{ $this->{'Societies'} }
        )
      )   { # ...
    $this->{'Society'} = $society ;  
    $this->makeList();
    } # ... end foreach;
  } # end sub;  
# ...................
sub makeList {
  my ($this) = @_ ;
  # ........................................
  $this->getNoEmailUserData ($this->{'Society'}) ;
  $this->getFormat();
  die ( "the this->format variable is empty. this->getFormat didn't Work? -Aborting!" ) 
    if ($this->{'format'} eq '');
    
  # ........................................
  $this->{'society_lists'}->{$this->{'Society'}} = '';  
  foreach my $member ( # ...
    keys ( # ...
    %{$this->{'noEmailMembers'} }
        )
      )   { # ...
    $this->{'society_lists'}->{$this->{'Society'}} .= 
      $this->printFormat(
        $this->{'format'}, 
        $this->{'noEmailMembers'}->{$member} 
        );
    }
  } # end sub;
# ...................
sub printList  {
  my ($this, $societyID) = @_ ;
  my $society_email = '';  
  if ( $societyID ne '' ) {
    $society_email = $this->{'Societies'}->{ $this->{'Society'} };  
    if ($this->{'mod'} eq 'send' ) {
      my $from = 'office@your-real-domain-name-here.org';
      my $cc = 'office@your-real-domain-name-here.org';
      my $to = 'leonid.heidt@your-real-domain-name-here.org';
      my $cmstr ="echo ".$this->{'society_lists'}{$societyID};
      $cmstr   .=" | mail -a 'From:<".$from.">' -c ";
      $cmstr   .="'".$cc."' -s 'Dear society administrator: The e-mail data field of";
      $cmstr   .=" the Memberships directory is now mandatory'";
      $cmstr   .=" ".$to ;
      system ("'".$cmstr."'");  
      exit;
      }
    else {    
      print "\n".$society_email."\n" ;
      print $this->{'society_lists'}->{$societyID} ;
      }
    }
  else {  
    foreach my $name (keys %{$this->{'society_lists'}}) {
      $society_email = $this->{'Societies'}->{ $name };  
      if ($this->{'mod'} eq 'send' ) {
        my $from = 'office@your-real-domain-name-here.org';
        my $cc = 'forum2012@your-real-domain-name-here.org';
        my $to = $society_email ;
        #system ("echo ".$this->{'society_lists'}{$societyID}
        #  ." | mail -a 'From:<".$from.">' -c "
        #  ."'".$cc."' -s 'Dear society administrator: The e-mail data field of"
        #  ." the Memberships directory is now mandatory'"
        #  ." ".$to
        #  ); 
        }
      else {
        print "\n".$society_email."\n" ;
        print "\n".$this->{'society_lists'}{$name} ;
        }
      }
    }  
  } # end sub;
# ...................
sub debug {
  my ($this,$what) = @_ ;
  unless ($what) {
    print Dumper($this) ;
    }
  else {
    print Dumper($what) ;
    }
  } # debug end;
# ...................
sub setCountryISOS {
  my ($this) = @_ ;
  my %hiso = ();
  $this->{'ISO'} = \%hiso;
  %hiso = (
      'Alemanha' => 'DE',
      'ALEMANIA' => 'DE',
      'ALGERIE' => 'AL',
      'Algérie' => 'AL',
      'Allemagne' => 'DE',
      'Anguilla' => 'AI',
      'Antarctica' => 'AQ',
      'Argentina' => 'AR',
      'ARGENTINA' => 'AR',
      'ARGENTINIA' => 'AR',
      'Armenia' => 'AM',
      'AUS' => 'AU',
      'Australia' => 'AU',
      'AUSTRALIA' => 'AU',
      'Australie' => 'AU',
      'Austria' => 'AT',
      'AUSTRIA' => 'AT',
      'AUT' => 'AT',
      'AUTRIA' => 'AT',
      'AZ'  => 'US',
      'Baltimore' => 'GB',
      'Barcelona' =>'ES',
      'BC'  =>'BG',
      'BE'  =>'BE',
      'BEL' =>'BE',
      'BelgiÎ'  =>'BE',
      'BELGICA' =>'BE',
      'Belgie'  =>'BE',
      'BELGIO'  =>'BE',
      'Belgique' =>'BE',
      'Belgium' =>'BE',
      'BELGIUM' =>'BE',
      'Berlin Germany' =>'DE',
      'BGR' =>'BG',
      'Bochum'  =>'DE',
      'Brasil'  =>'BR',
      'BRASILE' =>'BR',
      'Brazil'  =>'BR',
      'BRAZIL'  =>'BR',
      'BRD' =>'DE',
      'Brésil' =>'BR',
      'BRN' =>'BN',
      'Brunei Darussalam' =>'BN',
      'Buffalo' =>'US',
      'Bulgaria'  =>'BG',
      'CA'  =>'CA',
      'California'  =>'US',
      'CALIFORNIA'  =>'US',
      'Cambridge' =>'US',
      'CAN' =>'CA',
      'canada'  =>'CA',
      'Canada'  =>'CA',
      'CANADA'  =>'CA',
      'Ch'  =>'CL',
      'CH'  =>'CL',
      'CH-1015' =>'CL',
      'CHE' =>'CL',
      'Chile' =>'CL',
      'CHILE' =>'CL',
      'China' =>'CN',
      'CHINA' =>'CN',
      'CN'  =>'CN',
      'Colombia'  =>'CO',
      'Colombia South America'  =>'CO',
      'Copenhagen N'  =>'DK',
      'Costa Rica'  =>'CR',
      'CR'  =>'CR',
      'Croatia'  =>'HR',
      'Croatia Croatia' =>'HR',
      'CT'  =>'HR',
      'CUBA'  =>'CU',
      'Cyprus'  =>'CY',
      'CYPRUS'  =>'CY',
      'CZ'  =>'CZ',
      'CZE' =>'CZ',
      'Czech Republic'  =>'CZ',
      'CZECH REPUBLIC'  =>'CZ',
      'Danemark'  =>'DK',
      'DE'  =>'DE',
      'Denmark' =>'DK',
      'DENMARK' =>'DK',
      'DEU' =>'DE',
      'DEUTCHLAND'  =>'DE',
      'Deutschland' =>'DE',
      'DEUTSCHLAND' =>'DE',
      'Dubai-UAE' =>'AE-DU',
      'Ecuador' =>'EC',
      'Egypt' =>'EG',
      'Emeryville'  =>'CA',
      'EMIRATS ARABES UNIS'  =>'AE',
      'Engeland'  =>'GB',
      'England' =>'GB',
      'ES'  =>'ES',
      'ESP' =>'ES',
      'ESPAÑA'  =>'ES',
      'Espagne' =>'ES',
      'Espanha' =>'ES',
      'Estonia' =>'EE',
      'ESTONIA' =>'EE',
      'Etats-Unis'  =>'US',
      'FIN' =>'FI',
      'Finalnd' =>'FI',
      'Finland' =>'FI',
      'FINLAND' =>'FI',
      'Florianopolis' =>'GR',
      'FR'  =>'FR',
      'FRA' =>'FR',
      'france'  =>'FR',
      'France'  =>'FR',
      'FRANCE'  =>'FR',
      'FRANCIA' =>'FR',
      'Gambia'  =>'GM',
      'GB'  =>'GB',
      'GBR' =>'GB',
      'GE' =>'GE',
      'Georgia'  =>'GE', # Gruzien Gruzia
      'GEORGIA' =>'GE',
      'GER' =>'GE',
      'Germanay' =>'DE',
      'germany' =>'DE',
      'Germany' =>'DE',
      'GERMANY' =>'DE',
      'Germany Germany' =>'DE',
      'Grande-Bretagne' =>'GB',
      'GRC' =>'GR',
      'Grèce' =>'GR',
      'Greece'  =>'GR',
      'GREECE'  =>'GR',
      'Grenada' =>'GD',
      'Griechenland'  =>'GR',
      'Göttingen' =>'DE',
      'Hong Kong' =>'HK',
      'HONG KONG' =>'HK',
      'Hubei - PR China' =>'CN',
      'HUN' =>'HU',
      'Hungary' =>'HU',
      'HUNGARY' =>'HU',
      'Ibaraki' =>'JP',
      'Iceland' =>'IS',
      'IL'  =>'IL',
      'India' =>'IN',
      'INDIA' =>'IN',
      'Indianapolis'  =>'US',
      'IR'  =>'IR',
      'Iran'  =>'IR',
      'Iran(Islamic Republic Of)' =>'IR',
      'Iraq'  =>'IQ',
      'Ireland' =>'IE',
      'IRELAND' =>'IE',
      'Ireland Republic of Ireland' =>'IE',
      'IRL' =>'IE',
      'Irlande' =>'IE',
      'IRN' =>'IR',
      'Israel'  =>'IL',
      'ISRAEL'  =>'IL',
      'IT'  =>'IT',
      'ITA' =>'IT',
      'Itali' =>'IT',
      'Italia'  =>'IT',
      'ITALIA'  =>'IT',
      'Italie'  =>'IT',
      'ITALIE'  =>'IT',
      'Italt' =>'IT',
      'Italy' =>'IT',
      'ITALY' =>'IT',
      'Italy Italy' =>'IT',
      'Japan' =>'JP',
      'Japan.'  =>'JP',
      'JAPAN' =>'JP',
      'Japon' =>'JP',
      'JOR' =>'JO',
      'Jordan'  =>'JO',
      'JPN' =>'JP',
      'K01-10A The Netherlands' =>'NL',
      'Kingdom of Saudi Arabia' =>'SA',
      'Korea' =>'JO',
      'KOREA' =>'KR',
      'Korea, Republic of' =>'KR',
      'Kyoto' =>'JP',
      'Latvia' =>'LV',
      'Lazio Italy' =>'IT',
      'Lebanon' =>'LB',
      'LEBANON' =>'LB',
      'Liège' =>'BE',
      'Lihuania'  =>'LT',
      'Lithuania' =>'LT',
      'LU'  =>'LU',
      'Luxembourg'  =>'LU',
      'Macedonia' =>'MK',
      'Malaysia'  =>'MY',
      'MALAYSIA'  =>'MY',
      'Malta' =>'MT',
      'Maroc' =>'MA',
      'MD'  =>'MD',
      'Moldavia'  =>'MD',
      'MEX' =>'MX',
      'Mexico'  =>'MX',
      'MEXICO'  =>'MX',
      'Mexique' =>'MX',
      'MN'  =>'MN',
      'Mongolia'  =>'MN',
      'México'  =>'MX',
      'MÃ?XICO' =>'MX',
      'MYS' =>'MY',
      'N/A' =>'',
      'Nashville'=>'US',
      'NC'  =>'NC',
      'Nederland' =>'NL',
      'Netherlands' =>'NL',
      'New York'  =>'US',
      'New Zealand' =>'NZ',
      'NEW ZEALAND' =>'NZ',
      'Nigeria' =>'NG',
      'NIGERIA' =>'NG',
      'N.Ireland' =>'IE',
      'N. Ireland'  =>'IE',
      'NJ' =>'US',
      'NL'  =>'NL',
      'NLD' =>'NL',
      'NO'  =>'NO',
      'no address'  =>'',
      'NOR' =>'NO',
      'Northern Ireland' =>'IE',
      'NORUEGA' =>'NO',
      'Norvège' =>'NO',
      'Norway'  =>'NO',
      'NORWAY'  =>'NO',
      'Nova Scotia' => 'CA',
      'Novosibirsk' =>'RU',
      'NY' =>'US',
      'NZL' =>'NZ',
      'Oestereich' => 'AT',
      'ontario' =>'CA',
      'Ontario' =>'CA',
      'OR' => 'US', # Oregon US
      'Oregon' => 'US',
      'Oxfordshire' => 'GB',
      'PA' => 'PA',
      'Pakistan' => 'PK',
      'PALESTINE' => 'PS',
      'Paris' => 'FR',
      'Pays-Bas' =>'AT',
      'PERU' => 'PE',
      'POL' => 'PL',
      'Poland' => 'PL',
      'POLAND' => 'PL',
      'Poland Poland' => 'PL',
      'Polen' => 'PL',
      'Polska' => 'PL',
      'Portugal' => 'PT',
      'P. R. China' => 'CN',
      'PUERTO RICO' => 'PR',
      'Quebec' => 'CA',
      'Quebec  Canada' => 'CA',
      'Queensland,Australia' => 'AU',
      'Rep of Ireland' => 'IE',
      'Rep.of Ireland' => 'IE',
      'Republic of Ireland' => 'IE',
      'Republic of Moldova' => 'MD',
      'Rockville' => 'US',
      'Romania' =>'RO',
      'ROMANIA' =>'RO',
      'Romenia' =>'RO',
      'Royaume-Uni' =>'IE',
      'Rumänien' =>'RO',
      'Rusland' =>'RU',
      'Russia' =>'RU',
      'RUSSIA' =>'RU',
      'Russian Federation' =>'RU',
      'SAU' =>'SA',
      'Saudi Arabia' =>'SA',
      'Schweiz' =>'CH',
      'Scotland' =>'GB',
      'SCOTLAND' =>'GB',
      'Scotland/United Kingdom' =>'GB',
      'SE' =>'SE',
      'SE5 8AF' =>'SE',
      'Seden' => 'SE',
      'Seoul' =>'KR',
      'Serbia' =>'RS' ,
      'Serbia and Montenegro' => 'ME',
      'SGP' => 'SG',
      'Singapore' => 'SG',
      'SINGAPORE' => 'SG',
      'SK' =>'SK',
      'Slovakia' =>'SK',
      'Slovakia(Slovak Republic)' =>'SK',
      'Slovak Republic' =>'SK',
      'Slovenia' =>'SI',
      'SMR' => 'SM',
      'Soain' => 'ES', # A typing error from Spain
      'South Africa' => 'ZA',
      'South Korea' => 'KR',
      'South-Korea' => 'KR',
      'SP' => 'ES',
      'spain' => 'ES',
      'Spain' => 'ES',
      'SPAIN' => 'ES',
      'Spanje' => 'ES',
      'Sudan' => 'ES',
      'Suède' => 'SE',
      'Suisse' => 'CH', #Switzerland
      'SUISSE' => 'CH',
      'SUIZA' => 'CH',
      'Swedem' => 'SE',
      'Sweden' => 'SE',
      'SWEDEN' => 'SE',
      'Swiitzerland' => 'CH',
      'Swiss' => 'CH',
      'Switzeland' => 'CH',
      'Switzerland' => 'CH',
      'SWITZERLAND' => 'CH',
      'Switzerland Switzerland' => 'CH',
      'Swizerland' => 'CH',
      'Taiwan' => 'TW',
      'Tallahassee' => 'US', # Florida US
      'talu' =>'IT', #Naples 
      'THAILAND' => 'TH' ,
      'The Nederlands' => 'NL',
      'the Netherlands' => 'NL',
      'The Netherlands' => 'NL',
      'The Netherlands.' => 'NL',
      'THE NETHERLANDS' => 'NL',
      'The Netherlands / Norway' => 'NO',
      'The United States' => 'US',
      'the USA' => 'US',
      'TN' => 'US', #Memphis TN US
      'Toulouse' => 'IT',
      'TRNC' =>'TR', #Lefcose Turkey
      'Troy' => 'US', # NY USA
      'Tunisia' => 'TN',
      'Tunisie' => 'TN',
      'Turkey' =>'TR',
      'Turkiye' =>'TR',
      'Uk' =>'GB',
      'UK' =>'GB',
      'U.K.' =>'GB',
      'Ukraine' =>'UA',
      'UKRAINE' =>'UA',
      'UK Wales' =>'GB',
      'United Kingdom' =>'GB',
      'United Kingdom.' =>'GB',
      'United Kingdom United Kingdom' =>'GB',
      'United States' =>'US',
      'United States of America' =>'US',
      'Uruguay' =>'UY',
      'US' =>'US',
      'Usa' =>'US',
      'USA' =>'US',
      'U.S.A.' =>'US',
      'VA Hungary' =>'HU',
      'Vaud' => 'CH', # University of Lausanne
      'Venezuela' =>'VE',
      'VENEZUELA' =>'VE',
      'WALES' =>'GB',
      'Wales, UK' =>'GB',
      'Wales U.K.' =>'GB',
      'WA, USA' =>'US',
      'West Indies' =>'GB',
      'WHITERUSSIA' =>'BY', # Belarus - Belarussia
      'WI' => 'US',
      'Yugoslavia' =>'RS', # Beogorod - is now Serbia
      'Zurich' => 'CH',
      ) ;
  }
1;
