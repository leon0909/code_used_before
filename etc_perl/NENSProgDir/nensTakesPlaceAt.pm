#
##
##
##
#
package nensTakesPlaceAt ;
{
    use Data::Dumper::Simple ;
    use lib qw(/etc/perl/NENSProgDir);
    use dbActions;
    use nensInstitution;
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
  $properties{'type'} = 'nens.takesPlaceAt' ;
  # .............................
  ( # ...................
    $properties{'typeDB'}, 
    $properties{'typeTable'} 
    # ...................
    ) = $properties{'type'} =~ /^(.*?)\.(.*)/;
  $properties{'lastQuery'} = $lastQuery if ($lastQuery);
  $properties{'cttHash'  } = $cttHash   ;
  $properties{$properties{'type'}} = 'CourseID,InstitutionID,Type,Description' ;
  # 
  %{$this} = %properties ;
  $this->{'csv2sqlMap'  } = $csvpars->csv2sqlMap();
  $this->{'mapSql2Csv'} = $csvpars->mapSql2Csv();
  #$this->{'typeFields'} = 
  # .............................................
  print "\n -- IN :".$this->{'type'}.": -- \n";
  # in this object we handle the udate/insert procedures 
  # inside the getTakesPlaceAt function
  $this->getTakesPlaceAt($csvpars);
  $this;
  } # end sub ;
# ...................
sub getTakesPlaceAt {
  my ($this, $csvpars) = @_;
  # .............................................
  # ....The Host Institution and Contact Person Department
  # ....are using the same Institution table.............
  # ....That's why we parse here another field with the same purpose;
  # ....

  # ...................
  # 1. parse $this->{'cttHash'}->{'Host institution'} value
  # and parse $this->{'cttHash'}->{'Contact-Person-Institution-Department'} value
  # and extract each Institution and each Department picking them out from a 
  # comma separated string
  #
  # ...................
  # 2. call the nensInstitution object to get sure that every Institution is
  # already present in the nens.Institution table
  #
  # ....
  # we use the gierige regex here(so no -?- character)
  ( $this->{'ctDepartment'},
    $this->{'ctLabel'}
    ) = $this->{'cttHash'}->{'Contact-Person-Institution-Department'} =~ /^(.*\s?)(\,\s*.*)$/i ;
  $this->{'ctLabel'} =~ s/^\,\s+//;
  $this->{'ctLabel'} =~ s/Uni\./University /;
  $this->{'ctLabel'} =~ s/Univers\./University of /;
 # .............................................
  if ( defined ($this->{'ctLabel'}) && $this->{'ctLabel'} ne '') {
    # ....................
    $this->{'contact'}->{'Institution'} = $this->{'ctLabel'};
    $this->{'contact'}->{'Department'} = $this->{'ctDepartment'} ;
    }
  # .............................................
  ILABEL: {
  ('1') && do {
      # printf("\n%s\n%s\n",$this->{'cttHash'}->{'Host institution'},Dumper( $this->{'cttHash'}) ) ;
      ($this->{'Label'}, $this->{'Department'}) = $this->{'cttHash'}->{'Host institution'} =~ /^(.*?)(\,\s*.*)$/i ;
      $this->{'Department'} =~ s/^\,\s+//;
      $this->{'ihost'}->{'Institution'} = $this->{'Label'};
      $this->{'ihost'}->{'Department'} = $this->{'Department'} ;
      last ILABEL if ($this->{'Label'} ne '');
      };
  ('1') && do {
      ($this->{'Label'}, $this->{'Department'}) = $this->{'cttHash'}->{'Host institution'} =~ /^(.*?)(\(.*)$/i ;
      $this->{'ihost'}->{'Institution'} = $this->{'Label'};
      $this->{'ihost'}->{'Department'} = $this->{'Department'} ;
      last ILABEL if ($this->{'Label'} ne '');
      };
  ('1') && do {
      ($this->{'Label'}, $this->{'Department'}) = ( 
        $this->{'cttHash'}->{'Host institution'},
        ''
        );
      $this->{'ihost'}->{'Institution'} = $this->{'Label'};
      $this->{'ihost'}->{'Department'} = $this->{'Department'} ;
      last ILABEL ;
      };
    } # /ILABEL 
  # ..............................................
  $this->{'contactInstitution'} = new nensInstitution($this->{'contact'},$csvpars);
  # ...................
  $this->{'hostInstitution'} = new nensInstitution($this->{'ihost'},$csvpars);
  # print Dumper ($this);
  # ............................
  my @places = ('hostInstitution') ;
  foreach (@places) {
    $this->singleGet($_);
    $this->deleteTakesPlaceAt($_); 
    $this->insertTakesPlaceAt($_); 
    }
  } # end sub ;
# ...................
sub singleGet {
  my ($this, $InsttnKind) = @_;
  # ...................
  undef $this->{'lastQuery'} ;
  $this->{'lastQuery'}  = 'select '.$this->{$this->{'type'}}.' from '.$this->{'typeTable'}.' WHERE ';
  $this->{'lastQuery'} .= 'CourseID='.$this->{'cttHash'}->{'1D'}.' AND ';
  $this->{'lastQuery'} .= 'InstitutionID='.$this->{$InsttnKind}->{'aSetThatExists'}->{'ID'}.' AND ';
  # .............
  $this->{'lastQuery'} .= 'Type=1 ;' if ($InsttnKind =~ /^(host??)/)      ;
  $this->{'lastQuery'} .= 'Type=2 ;' if ($InsttnKind =~ /^(contact??)/) ;
  # .............
  my $myDB = new dbActions ('IsttnRows',$this->{'lastQuery'},$this->{'type'}) ;
  $this->{'aSetThatExists'}=$myDB->{'lastDBOutput'}->{$myDB->{'resultSet'}}  ;
  # print Dumper($this->{'aSetThatExists'});
  $this->{'emptySet'}='no'  if ($myDB->{'resultSet'} ne '');
  $this->{'emptySet'}='yes' if ($myDB->{'resultSet'} eq '');
  } # end sub ;
# ...................
sub deleteTakesPlaceAt {
  my ($this, $InsttnKind) = @_;
  # ...................
  undef $this->{'lastQuery'} ;
  # ...................
  $this->{'lastQuery'}  = 'delete from '.$this->{'typeTable'}.' WHERE ';
  $this->{'lastQuery'} .= 'CourseID='.$this->{'cttHash'}->{'1D'}.' AND ';
  $this->{'lastQuery'} .= 'InstitutionID='.$this->{$InsttnKind}->{'aSetThatExists'}->{'ID'}.' AND ';
  # .............
  $this->{'lastQuery'} .= 'Type=1 ;'  ;
  my $myDB = new dbActions ('delete',$this->{'lastQuery'},$this->{'type'}) ;
  # ...................
  undef $this->{'lastQuery'} ;
  # ...................
  }
# ...................
sub insertTakesPlaceAt {
  my ($this, $InsttnKind) = @_;
  # ...................
  undef $this->{'lastQuery'};
  # ...................
  my $fieldstr  = 'insert into '.$this->{'typeTable'}.' ('.$this->{$this->{'type'}}. ') ';
  my $valstr    = 'values ("'.$this->{'cttHash'}->{'1D'}.'", "';
  $valstr .= $this->{$InsttnKind}->{'aSetThatExists'}->{'ID'}.'", ';
  $valstr .= '1, '   if ($InsttnKind =~ /^(host??)/)     ;
  $valstr .= '2, '  if ($InsttnKind =~ /^(contact??)/) ;
  $valstr .= 'NULL ) ;';
  # ...................
  $this->{'lastQuery'} = $fieldstr.$valstr ;
  my $myDB = new dbActions ('insert',$this->{'lastQuery'},$this->{'type'}) ;
  # ...................
  undef $this->{'lastQuery'};
  } # end sub ;
}
# printf ("\n %s \n", $this->{'lastQuery'});

1; 

__END__
