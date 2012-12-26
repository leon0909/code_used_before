
-- IN :nens.Contact: --

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=576;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=576;';

dbA_ result set:1821
query:/select * from Contact where CourseID=576;/
CCCCresultSet:/1821/

-- IN :nens.City: --
$this->{'lastQuery'} = 'select ID,CountryID,Label,Coords from City where `Label`="London";';

dbA_ result set:147
query:/select ID,CountryID,Label,Coords from City where `Label`="London";/
CCCCresultSet:/147/

-- IN :nens.Country: --
$this->{'lastQuery'} = 'select ID,Label,Coords,ISO from Country where `Label`="UK";';

dbA_ result set:51
query:/select ID,Label,Coords,ISO from Country where `Label`="UK";/
CCCCresultSet:/51/

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Institute of Pharmacology Polish Academy of Sciences";';

dbA_ result set:2201
query:/select ID,Label,Department from Institution where `Label`="Institute of Pharmacology Polish Academy of Sciences";/
CCCCresultSet:/2201/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=576 AND InstitutionID=2201 AND Type=1 ;';

dbA_ result set:2201
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=576 AND InstitutionID=2201 AND Type=1 ;/
CCCCresultSet:/2201/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=576 AND InstitutionID=2201 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("576", "2201", 1, NULL ) ;';

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=576;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=576;';

dbA_ result set:1821
query:/select * from Contact where CourseID=576;/
CCCCresultSet:/1821/

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=576;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=576;';

dbA_ result set:1821
query:/select * from Contact where CourseID=576;/
CCCCresultSet:/1821/
$nc->{'ContactID'} = '1821';

 -- IN :nens.Course: --

-- IN :nens.offersDegree: --

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="Master";';

dbA_ result set:29
query:/select ID,Label,Category,Description from Degree where `Label`="Master";/
CCCCresultSet:/29/
$this->{'lastQuery'} = 'delete from  offersDegree where `CourseID`="576" ;';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("576", "29", 0 );';

-- IN :nens.requiresLanguage: --

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="English";';

dbA_ result set:2
query:/select ID,Label from Language where `Label`="English";/
CCCCresultSet:/2/
$this->{'lastQuery'} = 'delete from  requiresLanguage where `CourseID`="576" ;';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("576", "2", 0 );';

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Institute of Pharmacology Polish Academy of Sciences";';

dbA_ result set:2201
query:/select ID,Label,Department from Institution where `Label`="Institute of Pharmacology Polish Academy of Sciences";/
CCCCresultSet:/2201/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=576 AND InstitutionID=2201 AND Type=1 ;';

dbA_ result set:2201
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=576 AND InstitutionID=2201 AND Type=1 ;/
CCCCresultSet:/2201/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=576 AND InstitutionID=2201 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("576", "2201", 1, NULL ) ;';
$this->{'lastQuery'} = 'select * from Course where ID=576;';

dbA_ result set:576
query:/select * from Course where ID=576;/
CCCCresultSet:/576/

-- IN :nens.Contact: --

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=577;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=577;';

dbA_ result set:1831
query:/select * from Contact where CourseID=577;/
CCCCresultSet:/1831/

-- IN :nens.City: --
$this->{'lastQuery'} = 'select ID,CountryID,Label,Coords from City where `Label`="London";';

dbA_ result set:147
query:/select ID,CountryID,Label,Coords from City where `Label`="London";/
CCCCresultSet:/147/

-- IN :nens.Country: --
$this->{'lastQuery'} = 'select ID,Label,Coords,ISO from Country where `Label`="UK";';

dbA_ result set:51
query:/select ID,Label,Coords,ISO from Country where `Label`="UK";/
CCCCresultSet:/51/

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Georg August University Göttingen";';

dbA_ result set:1781
query:/select ID,Label,Department from Institution where `Label`="Georg August University Göttingen";/
CCCCresultSet:/1781/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=577 AND InstitutionID=1781 AND Type=1 ;';

dbA_ result set:1781
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=577 AND InstitutionID=1781 AND Type=1 ;/
CCCCresultSet:/1781/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=577 AND InstitutionID=1781 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("577", "1781", 1, NULL ) ;';

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=577;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=577;';

dbA_ result set:1831
query:/select * from Contact where CourseID=577;/
CCCCresultSet:/1831/

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=577;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=577;';

dbA_ result set:1831
query:/select * from Contact where CourseID=577;/
CCCCresultSet:/1831/
$nc->{'ContactID'} = '1831';

 -- IN :nens.Course: --

-- IN :nens.offersDegree: --

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="Master";';

dbA_ result set:29
query:/select ID,Label,Category,Description from Degree where `Label`="Master";/
CCCCresultSet:/29/
$this->{'lastQuery'} = 'delete from  offersDegree where `CourseID`="577" ;';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("577", "29", 0 );';

-- IN :nens.requiresLanguage: --

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="English";';

dbA_ result set:2
query:/select ID,Label from Language where `Label`="English";/
CCCCresultSet:/2/
$this->{'lastQuery'} = 'delete from  requiresLanguage where `CourseID`="577" ;';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("577", "2", 0 );';

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Georg August University Göttingen";';

dbA_ result set:1781
query:/select ID,Label,Department from Institution where `Label`="Georg August University Göttingen";/
CCCCresultSet:/1781/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=577 AND InstitutionID=1781 AND Type=1 ;';

dbA_ result set:1781
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=577 AND InstitutionID=1781 AND Type=1 ;/
CCCCresultSet:/1781/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=577 AND InstitutionID=1781 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("577", "1781", 1, NULL ) ;';
$this->{'lastQuery'} = 'select * from Course where ID=577;';

dbA_ result set:577
query:/select * from Course where ID=577;/
CCCCresultSet:/577/

-- IN :nens.Contact: --

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=578;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=578;';

dbA_ result set:1841
query:/select * from Contact where CourseID=578;/
CCCCresultSet:/1841/

-- IN :nens.City: --
$this->{'lastQuery'} = 'select ID,CountryID,Label,Coords from City where `Label`="Bristol";';

dbA_ result set:39
query:/select ID,CountryID,Label,Coords from City where `Label`="Bristol";/
CCCCresultSet:/39/

-- IN :nens.Country: --
$this->{'lastQuery'} = 'select ID,Label,Coords,ISO from Country where `Label`="UK";';

dbA_ result set:51
query:/select ID,Label,Coords,ISO from Country where `Label`="UK";/
CCCCresultSet:/51/

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Neuroscience Center Zurich";';

dbA_ result set:168
query:/select ID,Label,Department from Institution where `Label`="Neuroscience Center Zurich";/
CCCCresultSet:/168/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=578 AND InstitutionID=168 AND Type=1 ;';

dbA_ result set:168
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=578 AND InstitutionID=168 AND Type=1 ;/
CCCCresultSet:/168/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=578 AND InstitutionID=168 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("578", "168", 1, NULL ) ;';

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=578;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=578;';

dbA_ result set:1841
query:/select * from Contact where CourseID=578;/
CCCCresultSet:/1841/

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=578;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=578;';

dbA_ result set:1841
query:/select * from Contact where CourseID=578;/
CCCCresultSet:/1841/
$nc->{'ContactID'} = '1841';

 -- IN :nens.Course: --

-- IN :nens.offersDegree: --

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="PhD";';

dbA_ result set:35
query:/select ID,Label,Category,Description from Degree where `Label`="PhD";/
CCCCresultSet:/35/
$this->{'lastQuery'} = 'delete from  offersDegree where `CourseID`="578" ;';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("578", "35", 0 );';

-- IN :nens.requiresLanguage: --

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="English";';

dbA_ result set:2
query:/select ID,Label from Language where `Label`="English";/
CCCCresultSet:/2/
$this->{'lastQuery'} = 'delete from  requiresLanguage where `CourseID`="578" ;';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("578", "2", 0 );';

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Neuroscience Center Zurich";';

dbA_ result set:168
query:/select ID,Label,Department from Institution where `Label`="Neuroscience Center Zurich";/
CCCCresultSet:/168/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=578 AND InstitutionID=168 AND Type=1 ;';

dbA_ result set:168
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=578 AND InstitutionID=168 AND Type=1 ;/
CCCCresultSet:/168/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=578 AND InstitutionID=168 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("578", "168", 1, NULL ) ;';
$this->{'lastQuery'} = 'select * from Course where ID=578;';

dbA_ result set:578
query:/select * from Course where ID=578;/
CCCCresultSet:/578/

-- IN :nens.Contact: --

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=579;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=579;';

dbA_ result set:1851
query:/select * from Contact where CourseID=579;/
CCCCresultSet:/1851/

-- IN :nens.City: --
$this->{'lastQuery'} = 'select ID,CountryID,Label,Coords from City where `Label`="València";';

dbA_ result set:401
query:/select ID,CountryID,Label,Coords from City where `Label`="València";/
CCCCresultSet:/401/

-- IN :nens.Country: --
$this->{'lastQuery'} = 'select ID,Label,Coords,ISO from Country where `Label`="Spain";';

dbA_ result set:16
query:/select ID,Label,Coords,ISO from Country where `Label`="Spain";/
CCCCresultSet:/16/

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="University of Bologna";';

dbA_ result set:2211
query:/select ID,Label,Department from Institution where `Label`="University of Bologna";/
CCCCresultSet:/2211/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=579 AND InstitutionID=2211 AND Type=1 ;';

dbA_ result set:2211
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=579 AND InstitutionID=2211 AND Type=1 ;/
CCCCresultSet:/2211/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=579 AND InstitutionID=2211 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("579", "2211", 1, NULL ) ;';

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=579;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=579;';

dbA_ result set:1851
query:/select * from Contact where CourseID=579;/
CCCCresultSet:/1851/

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=579;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=579;';

dbA_ result set:1851
query:/select * from Contact where CourseID=579;/
CCCCresultSet:/1851/
$nc->{'ContactID'} = '1851';

 -- IN :nens.Course: --

-- IN :nens.offersDegree: --

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="Master";';

dbA_ result set:29
query:/select ID,Label,Category,Description from Degree where `Label`="Master";/
CCCCresultSet:/29/

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="PhD";';

dbA_ result set:35
query:/select ID,Label,Category,Description from Degree where `Label`="PhD";/
CCCCresultSet:/35/
$this->{'lastQuery'} = 'delete from  offersDegree where `CourseID`="579" ;';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("579", "35", 0 );';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("579", "29", 1 );';

-- IN :nens.requiresLanguage: --

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="Spanish";';

dbA_ result set:15
query:/select ID,Label from Language where `Label`="Spanish";/
CCCCresultSet:/15/

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="English";';

dbA_ result set:2
query:/select ID,Label from Language where `Label`="English";/
CCCCresultSet:/2/
$this->{'lastQuery'} = 'delete from  requiresLanguage where `CourseID`="579" ;';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("579", "2", 0 );';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("579", "15", 1 );';

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="University of Bologna";';

dbA_ result set:2211
query:/select ID,Label,Department from Institution where `Label`="University of Bologna";/
CCCCresultSet:/2211/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=579 AND InstitutionID=2211 AND Type=1 ;';

dbA_ result set:2211
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=579 AND InstitutionID=2211 AND Type=1 ;/
CCCCresultSet:/2211/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=579 AND InstitutionID=2211 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("579", "2211", 1, NULL ) ;';
$this->{'lastQuery'} = 'select * from Course where ID=579;';

dbA_ result set:579
query:/select * from Course where ID=579;/
CCCCresultSet:/579/

-- IN :nens.Contact: --

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=580;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=580;';

dbA_ result set:1861
query:/select * from Contact where CourseID=580;/
CCCCresultSet:/1861/

-- IN :nens.City: --
$this->{'lastQuery'} = 'select ID,CountryID,Label,Coords from City where `Label`="Rome";';

dbA_ result set:91
query:/select ID,CountryID,Label,Coords from City where `Label`="Rome";/
CCCCresultSet:/91/

-- IN :nens.Country: --
$this->{'lastQuery'} = 'select ID,Label,Coords,ISO from Country where `Label`="Italy";';

dbA_ result set:1
query:/select ID,Label,Coords,ISO from Country where `Label`="Italy";/
CCCCresultSet:/1/

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Sapienza University of Rome";';

dbA_ result set:1731
query:/select ID,Label,Department from Institution where `Label`="Sapienza University of Rome";/
CCCCresultSet:/1731/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="University of Trento";';

dbA_ result set:592
query:/select ID,Label,Department from Institution where `Label`="University of Trento";/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=580 AND InstitutionID=592 AND Type=1 ;';

dbA_ result set:592
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=580 AND InstitutionID=592 AND Type=1 ;/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=580 AND InstitutionID=592 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("580", "592", 1, NULL ) ;';

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=580;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=580;';

dbA_ result set:1861
query:/select * from Contact where CourseID=580;/
CCCCresultSet:/1861/

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=580;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=580;';

dbA_ result set:1861
query:/select * from Contact where CourseID=580;/
CCCCresultSet:/1861/
$nc->{'ContactID'} = '1861';

 -- IN :nens.Course: --

-- IN :nens.offersDegree: --

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="PhD";';

dbA_ result set:35
query:/select ID,Label,Category,Description from Degree where `Label`="PhD";/
CCCCresultSet:/35/
$this->{'lastQuery'} = 'delete from  offersDegree where `CourseID`="580" ;';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("580", "35", 0 );';

-- IN :nens.requiresLanguage: --

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="English";';

dbA_ result set:2
query:/select ID,Label from Language where `Label`="English";/
CCCCresultSet:/2/

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="Italian";';

dbA_ result set:1
query:/select ID,Label from Language where `Label`="Italian";/
CCCCresultSet:/1/
$this->{'lastQuery'} = 'delete from  requiresLanguage where `CourseID`="580" ;';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("580", "2", 0 );';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("580", "1", 1 );';

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Sapienza University of Rome";';

dbA_ result set:1731
query:/select ID,Label,Department from Institution where `Label`="Sapienza University of Rome";/
CCCCresultSet:/1731/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="University of Trento";';

dbA_ result set:592
query:/select ID,Label,Department from Institution where `Label`="University of Trento";/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=580 AND InstitutionID=592 AND Type=1 ;';

dbA_ result set:592
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=580 AND InstitutionID=592 AND Type=1 ;/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=580 AND InstitutionID=592 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("580", "592", 1, NULL ) ;';
$this->{'lastQuery'} = 'select * from Course where ID=580;';

dbA_ result set:580
query:/select * from Course where ID=580;/
CCCCresultSet:/580/

-- IN :nens.Contact: --

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=582;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=582;';

dbA_ result set:1871
query:/select * from Contact where CourseID=582;/
CCCCresultSet:/1871/

-- IN :nens.City: --
$this->{'lastQuery'} = 'select ID,CountryID,Label,Coords from City where `Label`="Mainz";';

dbA_ result set:51
query:/select ID,CountryID,Label,Coords from City where `Label`="Mainz";/
CCCCresultSet:/51/

-- IN :nens.Country: --
$this->{'lastQuery'} = 'select ID,Label,Coords,ISO from Country where `Label`="Germany";';

dbA_ result set:5
query:/select ID,Label,Coords,ISO from Country where `Label`="Germany";/
CCCCresultSet:/5/

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="University of Trento";';

dbA_ result set:592
query:/select ID,Label,Department from Institution where `Label`="University of Trento";/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=582 AND InstitutionID=592 AND Type=1 ;';

dbA_ result set:592
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=582 AND InstitutionID=592 AND Type=1 ;/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=582 AND InstitutionID=592 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("582", "592", 1, NULL ) ;';

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=582;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=582;';

dbA_ result set:1871
query:/select * from Contact where CourseID=582;/
CCCCresultSet:/1871/

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=582;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=582;';

dbA_ result set:1871
query:/select * from Contact where CourseID=582;/
CCCCresultSet:/1871/
$nc->{'ContactID'} = '1871';

 -- IN :nens.Course: --

-- IN :nens.offersDegree: --

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="MD-PhD";';

dbA_ result set:101
query:/select ID,Label,Category,Description from Degree where `Label`="MD-PhD";/
CCCCresultSet:/101/
$this->{'lastQuery'} = 'delete from  offersDegree where `CourseID`="582" ;';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("582", "101", 0 );';

-- IN :nens.requiresLanguage: --

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="English";';

dbA_ result set:2
query:/select ID,Label from Language where `Label`="English";/
CCCCresultSet:/2/
$this->{'lastQuery'} = 'delete from  requiresLanguage where `CourseID`="582" ;';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("582", "2", 0 );';

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="University of Trento";';

dbA_ result set:592
query:/select ID,Label,Department from Institution where `Label`="University of Trento";/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=582 AND InstitutionID=592 AND Type=1 ;';

dbA_ result set:592
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=582 AND InstitutionID=592 AND Type=1 ;/
CCCCresultSet:/592/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=582 AND InstitutionID=592 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("582", "592", 1, NULL ) ;';
$this->{'lastQuery'} = 'select * from Course where ID=582;';

dbA_ result set:582
query:/select * from Course where ID=582;/
CCCCresultSet:/582/

-- IN :nens.Contact: --

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=584;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=584;';

dbA_ result set:1881
query:/select * from Contact where CourseID=584;/
CCCCresultSet:/1881/

-- IN :nens.City: --
$this->{'lastQuery'} = 'select ID,CountryID,Label,Coords from City where `Label`="Innsbruck";';

dbA_ result set:25
query:/select ID,CountryID,Label,Coords from City where `Label`="Innsbruck";/
CCCCresultSet:/25/

-- IN :nens.Country: --
$this->{'lastQuery'} = 'select ID,Label,Coords,ISO from Country where `Label`="Austria";';

dbA_ result set:3
query:/select ID,Label,Coords,ISO from Country where `Label`="Austria";/
CCCCresultSet:/3/

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Universita Politecnica delle Marche";';

dbA_ result set:2221
query:/select ID,Label,Department from Institution where `Label`="Universita Politecnica delle Marche";/
CCCCresultSet:/2221/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=584 AND InstitutionID=2221 AND Type=1 ;';

dbA_ result set:2221
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=584 AND InstitutionID=2221 AND Type=1 ;/
CCCCresultSet:/2221/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=584 AND InstitutionID=2221 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("584", "2221", 1, NULL ) ;';

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=584;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=584;';

dbA_ result set:1881
query:/select * from Contact where CourseID=584;/
CCCCresultSet:/1881/

 Query :/$this->{'lastQuery'} = 'select * from Contact where CourseID=584;';
/:
$this->{'lastQuery'} = 'select * from Contact where CourseID=584;';

dbA_ result set:1881
query:/select * from Contact where CourseID=584;/
CCCCresultSet:/1881/
$nc->{'ContactID'} = '1881';

 -- IN :nens.Course: --

-- IN :nens.offersDegree: --

-- IN :nens.Degree: --
$this->{'lastQuery'} = 'select ID,Label,Category,Description from Degree where `Label`="PhD";';

dbA_ result set:35
query:/select ID,Label,Category,Description from Degree where `Label`="PhD";/
CCCCresultSet:/35/
$this->{'lastQuery'} = 'delete from  offersDegree where `CourseID`="584" ;';
$this->{'lastQuery'} = 'insert into offersDegree (CourseID,DegreeID,Priority) values ("584", "35", 0 );';

-- IN :nens.requiresLanguage: --

-- IN :nens.Language: --
$this->{'lastQuery'} = 'select ID,Label from Language where `Label`="English";';

dbA_ result set:2
query:/select ID,Label from Language where `Label`="English";/
CCCCresultSet:/2/
$this->{'lastQuery'} = 'delete from  requiresLanguage where `CourseID`="584" ;';
$this->{'lastQuery'} = 'insert into requiresLanguage (CourseID,LanguageID,Priority) values ("584", "2", 0 );';

 -- IN :nens.takesPlaceAt: -- 

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="";';

dbA_ result set:134
query:/select ID,Label,Department from Institution where `Label`="";/
CCCCresultSet:/134/

 -- IN :nens.Institution: -- 
$this->{'lastQuery'} = 'select ID,Label,Department from Institution where `Label`="Universita Politecnica delle Marche";';

dbA_ result set:2221
query:/select ID,Label,Department from Institution where `Label`="Universita Politecnica delle Marche";/
CCCCresultSet:/2221/
$this->{'lastQuery'} = 'select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=584 AND InstitutionID=2221 AND Type=1 ;';

dbA_ result set:2221
query:/select CourseID,InstitutionID,Type,Description from takesPlaceAt WHERE CourseID=584 AND InstitutionID=2221 AND Type=1 ;/
CCCCresultSet:/2221/
$this->{'lastQuery'} = 'delete from takesPlaceAt WHERE CourseID=584 AND InstitutionID=2221 AND Type=1 ;';
$this->{'lastQuery'} = 'insert into takesPlaceAt (CourseID,InstitutionID,Type,Description) values ("584", "2221", 1, NULL ) ;';
$this->{'lastQuery'} = 'select * from Course where ID=584;';

dbA_ result set:
query:/select * from Course where ID=584;/
CCCCresultSet://
$this->{'lastQuery'} = 'insert into Course ( ID, OwnerID, Created, Modified, Status, Website, Label, Duration ) values (584, 1881, 1351785380, 1351785380, 1, "www.neurospin.at", "SPIN - Signal Processing in Neurons", "3-4 years");';
