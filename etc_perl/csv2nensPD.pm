#!/usr/bin/perl -w

# ...............................................  
package csv2nensPD ;
{
    use Data::Dumper::Simple ;
    use lib qw(/etc/perl/NENSProgDir);
    use base ('csvParse');
    use nensContact;
    use nensInstitution;
    use nensCourse;
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
  my ( $this, $CSVPath ) = @_;
  $this->{'csv-path'} = $CSVPath;
  my $cPsd = new csvParse($this->{'csv-path'});
  $this->{'csv2sqlMap'} = $cPsd->{'csv2sqlMap'} ;
  $this->{'mapSql2Csv'} = $cPsd->{'mapSql2Csv'} ;
  $this->{'allRows'} = $cPsd->{'allRows'} ;
  # .............................................
  $this->csv2db ($cPsd) ;
  }
# ...........................
sub csv2db {
  # .............................
  my ( $this, $cPsd ) = @_;
  # ...................
  foreach my $row (@{$this->{'allRows'}}) {
    my $nc = new nensContact ($row,$cPsd);
    print Dumper($nc->{'ContactID'});
    my $ncu = new nensCourse ($row,$cPsd,$nc->{'ContactID'});
    }
  }
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
