#
##
##
##
#

package csvParse ;
{
  use Data::Dumper::Simple ;
  use lib qw(/etc/perl/NENSProgDir);
  use strict;
  no strict 'refs';
# ...............................................  
sub new {
  # .............................................
  my $selfName = shift;
  my $this     =    {};
  # .. Referenz auf anonymen hash ;
  bless($this, $selfName);
  $this->_init(@_);
  $this;
  } # end sub ;
# ...................
sub _init {
  # .............................
  my ( $this, $CSVPath ) = @_;
  # ...................
  my %properties =() ;
  $properties{'csv-path'} = $CSVPath;
  $properties{'csv2sqlMap'  } = {
    '1D'                           => 'Course:ID', #/* Primary Key in Course and Foreign key for the Course in Contact */
    'Program Name'                 => 'Course:Label', #/* See Course Fields */
    'Programme Website'            => 'Course:Website', #/* See Course Fields */
    'Duration of the program'      => 'Course:Duration', #/* See Course Fields */
    'Program language'             => 'Language:Label', #/* tables requiresLanguage and over its foreign key - Language  */
    'Degree(s) available'          => 'Degree:Label', #/* Foreign Key */
    'Phone'                        => 'Contact:Phone', #/* See Contact Fields */
    'Fax'                          => 'Contact:Fax', #/* See Contact Fields */
    "Coordinator's e-mail address" => 'Contact:Email', #/* See Contact Fields */
    'Website'                      => 'Contact:Website', #/* See Contact Fields  */
    'Contact Person'               => 'Contact:Name', #/* See Contact Fields */
    'Contact-Person-Street'        => 'Contact:Street', # /* See Contact Fields */
    'ZIP code'                     => 'Contact:Zipcode', #/* See Contact Fields */
    'Contact-Person-Country'       => 'Country:Label', #/* Foreign Key to nens.City.CountryID */
    'Contact-Person City'          => 'City:Label', #/* Foreign Key to nens.City */
    'Contact-Person-Institution-Department' => 'Institution:Department', #/* See Fields in Institution */
    'Host Institution'             => 'Institution:Label', # /* its ID is a Foreign Key in Contact  */
    'Main-Keywords'                => 'Main-Keywords:Label', #/* */
    'Keywords'                     => 'Keywords:Label' #/* */
    };
  # .............................................
  %{$this} = %properties ;
  $this->{'mapSql2Csv'}->{$this->{'csv2sqlMap'}->{$_}} = $_ for keys %{$this->{'csv2sqlMap'}};
  # .............................................
  $this->readCSV () ;
  }
# ...........................
sub csv2sqlMap {
  my ( $this ) = @_;
  $this->{'csv2sqlMap'};
  }
# ...........................
sub mapSql2Csv {
  my ( $this ) = @_;
  $this->{'mapSql2Csv'};
  }
# ...........................
sub allRows {
  my ( $this ) = @_;
  $this->{'allRows'};
  }
# ...........................
sub readCSV {
  # .............................
  my ( $this ) = @_;
  # ...................
  open CSV, "<", $this->{'csv-path'} or die $this->{'csv-path'}.": $!";
  my $count = 0;
  while (<CSV>) {
    my ($line,) = $_ =~ /^;(\d+.*)$/;
    chomp ($line);
    my @fields = ();
    my $act=1;
    @fields = split ';', $line;
    chomp @fields;
    if ( $fields[0] =~ /1D/i ) {
      # ..........................
      $act=$#fields;
      for (my $i=0; $i<@fields; $i++) {
        # ..........................
        $this->{'fieldNames'}->{$i} = $fields[$i]; 
        } # foreach
      } # fi
    else {
      # ..........................
      $act=$#fields;
      for (my $i=0;$i<@fields;$i++) {
        # ..........................
        $this->{'row'.$count}->{$this->{'fieldNames'}->{$i}} = $fields[$i];
        } # foreach
      push (@{$this->{'allRows'}},$this->{'row'.$count});   
      } # else
    $count ++;  
    } # while
  } # readCSV end;
# ...................
 # if ( $count eq '1' ) {    
 #   printf("%s\n",Dumper($this->{'allRows'}));
 #   exit;
 #  }
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
}

1;

__END__
