%% GNAT Demo 3
% This demo shows how to construct an O-linked glycosylation pathway on
% PGSL-1 developed by Liu et al. (Bioinformatic, 2008).  The inputs are 12
% glycan structures and 5 enzymes.

%% Enzyme definition
% define beta1.4 GalTIV, beta 1,3 GlcNAcTgnte enzyme,
%  alpha2,3ST3Gal-I , alpha2,3ST3Gal-IV , and alpha1,3FT-VII

galtiv                                 = GTEnz([2;4;1;38]);
residueMap                       = load('residueTypes.mat');
galtiv.isTerminalTarget  = true;
galtiv.resfuncgroup        = residueMap.allresidues('Gal');
glcnacResType                = residueMap.allresidues('GlcNAc');
glcnacBond                     = GlycanBond('?','1');
galtiv.resAtt2FG              = glcnacResType;
galtiv.linkresAtt2FG        = struct('bond', glcnacBond,'anomer','b');
galtbond                          = GlycanBond('4','1');
galtiv.linkFG                    =  struct('anomer','b','bond',galtbond);

ignt                                        = GTEnz([2;4;1;149]);
ignt.isTerminalTarget          = true;
ignt.resfuncgroup                = residueMap.allresidues('GlcNAc');
galResType                           = residueMap.allresidues('Gal');
galBond                                = GlycanBond('4','1');
ignt.resAtt2FG                = galResType;
ignt.linkresAtt2FG  = struct(...
    'bond', galBond,'anomer','b');
glcnacbond = GlycanBond('3','1');
ignt.linkFG   = struct('anomer','b','bond',glcnacbond);

st3galI                                      = GTEnz([2;4;99;4]);
st3galI.isTerminalTarget        = true;
st3galI.resfuncgroup              = residueMap.allresidues('NeuAc');
galResType                              = residueMap.allresidues('Gal');
galBond                                   = GlycanBond('3','1');
st3galI.resAtt2FG               =  galResType;
st3galI.linkresAtt2FG               = struct( 'bond', galBond,'anomer','b');
st3bond                                    = GlycanBond('3','2');
st3galI.linkFG                           = struct('anomer','a','bond',st3bond);

st3galIV                                     = GTEnz([2;4;99;6]);
st3galIV.isTerminalTarget      = true;
st3galIV.resfuncgroup            = residueMap.allresidues('NeuAc');
galResType                               = residueMap.allresidues('Gal');
galBond                                    = GlycanBond('4','1');
st3bond                                    = GlycanBond('3','2');
st3galIV.linkFG                         = struct('anomer','a','bond',st3bond);
st3galIV.resAtt2FG                  = galResType;
st3galIV.linkresAtt2FG            = struct('bond', galBond,'anomer','b');

fucT7                                         = GTEnz([2;4;1;152]);
fucT7.isTerminalTarget           = false;
fucT7.resfuncgroup                 = residueMap.allresidues('Fuc');
fuctbond                                   = GlycanBond('4','1');
fucT7.linkFG                              = struct('anomer','a','bond',fuctbond);

glcnacResType                          = residueMap.allresidues('GlcNAc');
glcnacBond                               = GlycanBond('3','1');
fucT7.resAtt2FG                        =  glcnacResType;
fucT7.linkresAtt2FG                  =  struct('bond', glcnacBond,'anomer','?');
fucT7.substNAResidue             = residueMap.allresidues('Fuc');
fucT7.substMinStruct               =  glycanMLread('fucT7substmin.glycoct_xml');
%enzViewer(fucT7);

%%  Inputs of Glycan Structure
%  12 Glycan structure are constructed using Glycoworkench toolbox and they
%   are stored as Glycoct xml format. These files can be imported into
%   GNAT.
%
s1species = GlycanSpecies(glycanMLread('OG1.glycoct_xml'));
s2species = GlycanSpecies(glycanMLread('OG2.glycoct_xml'));
s4species = GlycanSpecies(glycanMLread('OG4.glycoct_xml'));
s5species = GlycanSpecies(glycanMLread('OG5.glycoct_xml'));
s7species = GlycanSpecies(glycanMLread('OG7.glycoct_xml'));
s10species = GlycanSpecies(glycanMLread('OG10.glycoct_xml'));
s11species = GlycanSpecies(glycanMLread('OG11.glycoct_xml'));
s13species = GlycanSpecies(glycanMLread('OG13.glycoct_xml'));
s14species = GlycanSpecies(glycanMLread('OG14.glycoct_xml'));
s17species = GlycanSpecies(glycanMLread('OG17.glycoct_xml'));
s18species = GlycanSpecies(glycanMLread('OG18.glycoct_xml'));
s19species = GlycanSpecies(glycanMLread('OG19.glycoct_xml'));
s20species = GlycanSpecies(glycanMLread('OG20.glycoct_xml'));

%% Storage of enzymes and glycans in the CellArrayList variables
%  Two input variables are created as CellArrayList variables and store
%    a list of enzymes and glyan structure respectively.
%
glycanArray = CellArrayList;
glycanArray.add(s1species);
glycanArray.add(s2species);
glycanArray.add(s4species);
glycanArray.add(s5species);
glycanArray.add(s7species);
glycanArray.add(s10species);
glycanArray.add(s11species);
glycanArray.add(s13species);
glycanArray.add(s17species);
glycanArray.add(s14species);
glycanArray.add(s18species);
glycanArray.add(s19species);
glycanArray.add(s20species);

enzArray  = CellArrayList;
enzArray.add(ignt);
enzArray.add(galtiv);
enzArray.add(st3galI);
enzArray.add(st3galIV);
enzArray.add(fucT7);

%% Network reconstruction from inputs of glycans and enzymes
%  An O-linked glycosylation network can be constructed from 12 defined
%   glycan structures and 5 enzymes using inferGlyConnPath command.
%
[isPath,oglycanpath]=inferGlyConnPath(glycanArray, enzArray);

%% Visualization of Reconstructed Network
if(isPath)
    glycanPathViewer(oglycanpath);
end

%% Subset Network Modeling

% define 6 group of glycans
subgroupArray = CellArrayList;
group1Array = CellArrayList;
group1Array.add(s2species);
group2Array = CellArrayList;
group2Array.add(s4species);
group2Array.add(s5species);
group3Array = CellArrayList;
group3Array.add(s7species);
group4Array = CellArrayList;
group4Array.add(s10species);
group4Array.add(s11species);
group4Array.add(s13species);
group5Array = CellArrayList;
group5Array.add(s14species);
group5Array.add(s17species);
group6Array = CellArrayList;
group6Array.add(s18species);
group6Array.add(s19species);
group6Array.add(s20species);
group7Array = CellArrayList;
group7Array.add(s1species);

% subgroupArray.add(group1Array);
% subgroupArray.add(group2Array);
% subgroupArray.add(group3Array);
% subgroupArray.add(group4Array);
subgroupArray.add(group5Array);
% subgroupArray.add(group6Array);
% subgroupArray.add(group7Array);

iniSubsArray         = CellArrayList;
iniSubsArray.add(s1species);

totalpathlist          = CellArrayList;
numspeciestodel = 1;
totalNSpecies       = oglycanpath.getNSpecies;
nspeciesToStay    = totalNSpecies - numspeciestodel;
comblistindex      = combinator(totalNSpecies,nspeciesToStay,'c') ; 

fprintf(1,'the number of the pathway before checking is:%f \n',...
    length(comblistindex));
validpathlist = CellArrayList;
for i = 1 : length(comblistindex)
    disp(i);
    listindex = comblistindex(i,:);
    listofsubspecies = oglycanpath.theSpecies.get(listindex);
    subspeciesinput = CellArrayList;
    subspeciesinput.add(listofsubspecies);    
    subpath = subnetgenbyspeckeep(oglycanpath,subspeciesinput);    
    ispathvalid = isvalidOglycanpath(subpath,subgroupArray,iniSubsArray,glycanArray);
    if(ispathvalid)
       validpathlist.add(subpath);
    end    
end
fprintf(1,'the number of the pathway after checking is:%f \n',validpathlist.length);