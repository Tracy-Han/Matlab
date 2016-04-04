% This file is for output MayaScripts
clc; clear all;
% Setting input file location and ouput file location
ModelFolder = 'D:\TriangleOrdering\Models';
ScriptFolder = 'D:\TriangleOrdering\Maya\Script';
vfFolder =  'D:\TriangleOrdering\VF\Obj';
vfFolder_slash = 'D:/TriangleOrdering/VF/Obj';
% mkdir(vfFolder);
charIndex = 1;Duration = [50,70,50,45,40,75];
Selects = {'Ganfaul','Kachujin','MAW','Nightshade'};
%% Setting Parameters
aniFolder = [ModelFolder,'\Animation'];
charFolder = [ModelFolder,'\Character'];
charFolder_slash = 'D:/TriangleOrdering/Models/Character';
aniFolder_slash = 'D:/TriangleOrdering/Models/Animation';
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
for charIndex = 1:4
    select = Selects{charIndex};
   
    for subdivLevel = 2:2
        countSub =0; % subdivide once
        outFile = [Character{charIndex},'_script',num2str(subdivLevel),'.txt'];
        oldFolder = cd(ScriptFolder);
        fileId = fopen(outFile,'w');
        
        fprintf(fileId,'%s \n','file -f - new ;');
        % import model
        temp = ['file -import -type "DAE_FBX" -ignoreVersion -ra true'...
            '-mergeNamespacesOnClash false -namespace '];
        inpath = [charFolder_slash,'/',Character{charIndex},'.dae'];
        readChar = [temp,'"',Character{charIndex},'" -options "dae"  -pr ','"',inpath,'";'];
        fprintf(fileId,'%s \n',readChar);
    % writing the editors
    for y=1:length(Animation)
        duration = Duration(y);
        % new animation
       
        temp2 = ['file -import -type "FBX" -ignoreVersion -ra true'...
            '-mergeNamespacesOnClash false -namespace '];
        inpath2 = [aniFolder_slash,'/',Animation{y},'.fbx'];
        readAni = [temp2,'"',Animation{y},'" -options "fbx"  -pr ','"',inpath2,'" ;'];
        fprintf(fileId,'%s \n',readAni);
 
        % select mesh
        selectMesh = ['select -r ',select,' ;'];
        fprintf(fileId,'%s \n',selectMesh);
        % clean mesh
        cleanMesh ='polyCleanupArgList 3 { "0","1","1","1","1","0","0","0","0","1e-005","0","1e-005","0","1e-005","0","-1","0" };';
        fprintf(fileId,'%s \n',cleanMesh);
        % save obj files
        % nosub
        temp = ['file - force -options "groups=0;ptgroups=0;materials=0;smoothing=1;normals=0"'...
             '-typ "OBJexport" -pr -es '];
         if subdivLevel == 0
            outpath = [vfFolder_slash,'/',Character{charIndex},'/',Animation{y},'/nosub'];
            for i=1:duration
                fprintf(fileId,'currentTime %d;\n',i);
                path = [outpath,'/frame',num2str(i),'.obj'];
                savefile = [temp,'"',path,'";'];
                fprintf(fileId,'%s\n',savefile);
            end
         elseif subdivLevel == 1
        % subdiv1
            if countSub == 0
                subdivMesh =[ 'polySubdivideFacet -dv 1 -m 1 -ch 1 ',select,' ;'];
                countSub = countSub+1;
                fprintf(fileId,'%s \n',subdivMesh);
            end
            
            outpath = [vfFolder_slash,'/',Character{charIndex},'/',Animation{y},'/subdiv1'];
            for i=1:duration
                fprintf(fileId,'currentTime %d;\n',i);
                path = [outpath,'/frame',num2str(i),'.obj'];
                savefile = [temp,'"',path,'";'];
                fprintf(fileId,'%s\n',savefile);
            end
         elseif subdivLevel == 2
        %subdiv2
            if countSub == 0
                %subdivMesh =[ 'polySubdivideFacet -dv 2 -m 1 -ch 1 ',select,' ;'];
                smoothMesh = ['polySmooth  -mth 0 -sdt 2 -ovb 1 -ofb 3 -ofc 0 -ost 1 -ocr 0 -dv 1 '... 
                    '-bnr 1 -c 1 -kb 1 -ksb 1 -khe 0 -kt 1 -kmb 1 -suv 1 -peh 0 -sl 1 -dpe 1 -ps 0.1 -ro 1 -ch 1 ',select,' ;'];
                countSub = countSub+1;
                %fprintf(fileId,'%s \n',subdivMesh);
                fprintf(fileId,'%s \n',smoothMesh);
                triangulateMesh = ['polyTriangulate -ch 1 ',select,' ;'];
                fprintf(fileId,'%s \n',triangulateMesh);
            end
            
            outpath = [vfFolder_slash,'/',Character{charIndex},'/',Animation{y},'/subdiv2'];
            for i=1:duration
                fprintf(fileId,'currentTime %d;\n',i);
                path = [outpath,'/frame',num2str(i),'.obj'];
                savefile = [temp,'"',path,'";'];
                fprintf(fileId,'%s\n',savefile);
            end
         end
    end
    fclose(fileId);
    cd(oldFolder);
    end
end