% This file is for output MayaScripts
clc; clear all;
% Setting input file location and ouput file location
ModelFolder = 'D:\TriangleOrdering\Models';
ScriptFolder = 'D:\TriangleOrdering\Maya\Script';
vfFolder =  'D:\TriangleOrdering\VF\Obj';
vfFolder_slash = 'D:/TriangleOrdering/VF/Obj';
% mkdir(vfFolder);
charIndex = 1;Duration = [50,70,50,45,40,40,75,65];
%% Setting Parameters
aniFolder = [ModelFolder,'\Animation'];
charFolder = [ModelFolder,'\Character'];
oldFolder = cd(aniFolder);
Animation = {};
file = dir('*.fbx');
for i=1:length(file)
    Animation(i) = cellstr(file(i).name(1:end-4));
end
cd(oldFolder);
oldFolder = cd(charFolder);
Character = {};
file = dir('*.dae');
for i =1:length(file)
    Character(i) = cellstr(file(i).name(1:end-4));
end
cd(oldFolder);
% make directory
% oldFolder = cd(vfFolder);
% for i=1:length(Character)
%     mkdir([Character{i}]);
%     for j =1:length(Animation)
%        foldername = [Character{i},'/',Animation{j}];
%        mkdir(foldername);
%     end
% end
% cd(oldFolder);

%% Output one character ScriptEditor
for charIndex = 1:5
outFile = [Character{charIndex},'_script.txt'];
oldFolder = cd(ScriptFolder);
fileId = fopen(outFile,'w');
% writing the editors
for y=1:length(Animation)
        duration = Duration(y);
        % new scene
        fprintf(fileId,'%s \n','file -f - new ;');
%         % import model
%         temp = ['file -import -type "DAE_FBX" -ignoreVersion -ra true'...
%             '-mergeNamespacesOnClash false -namespace '];
%         inpath = [charFolder2,'/',Character{charIndex},'.dae'];
%         readChar = [temp,'"',Character{charIndex},'" -options "dae"  -pr ','"',inpath,'";'];
%         fprintf(fileId,'%s \n',readChar);
%         temp2 = ['file -import -type "FBX" -ignoreVersion -ra true'...
%             '-mergeNamespacesOnClash false -namespace '];
%         inpath2 = [aniFolder2,'/',Animation{y},'.fbx'];
%         readAni = [temp2,'"',Animation{y},'" -options "fbx"  -pr ','"',inpath2,'"'];
%         fprintf(fileId,'%s \n',readAni);
%         % select mesh
%         selectMesh = ['select -r ',select,' ;'];
%         fprintf(fileId,'%s \n',selectMesh);
        % clean mesh
        cleanMesh ='polyCleanupArgList 3 { "0","1","1","1","1","0","0","0","0","1e-005","0","1e-005","0","1e-005","0","-1","0" };';
        fprintf(fileId,'%s \n',cleanMesh);
        % save obj files
        temp = ['file - force -options "groups=0;ptgroups=0;materials=0;smoothing=1;normals=0"'...
             '-typ "OBJexport" -pr -es '];
        outpath = [vfFolder_slash,'/',Character{charIndex},'/',Animation{y}];

        for i=1:duration
            fprintf(fileId,'currentTime %d;\n',i);
            path = [outpath,'/frame',num2str(i),'.obj'];
            savefile = [temp,'"',path,'";'];
            fprintf(fileId,'%s\n',savefile);
        end
 end
fclose(fileId);
cd(oldFolder);
end