function [ posMat, posConf, oriMat, oriConf ] = loadUCFSkeleton( filename )
%loadSkeleton parses a skeleton file
%   posMat: (frame,user,joint,idx)
%       vectors of 3D joint positions (x,y,z)
%   posConf: (frame,user,joint)
%       joint position confidence levels
%   oriMat: (frame,user,joint,idx1,idx2)
%       3x3 matrices of joint orientations
%   oriConf: (frame,user,joint)
%       joint orientation confidence levels


fid = fopen(filename);
line = fgetl(fid);
while ischar(line)
    % parse frame title and index
    [t,line] = strtok(line,'|');
    [tmp,line] = strtok(line,'|');
    frame = str2num(tmp)+1;
    
    % parse numUsers title and value
    [t,line] = strtok(line,'|');
    [tmp,line] = strtok(line,'|');
    numUsers = str2num(tmp);
    
    % step through each user
    for user = 1:numUsers
        % parse userID title and value
        [t,line] = strtok(line,'|');
        [tmp,line] = strtok(line,'|');
        userID = str2num(tmp);
        
        % parse numJoints title and value
        [t,line] = strtok(line,'|');
        [tmp,line] = strtok(line,'|');
        numJoints = str2num(tmp);
        
        % step through each joint
        for joint = 1:numJoints
            % parse joint title and value
            [t,line] = strtok(line,'|');
            [tmp,line] = strtok(line,'|');
            
            % this line preserves the joint IDs from OpenNI
            %jointID = str2num(tmp);
            % ---or---
            % this line renumbers the joint IDs for ease of array manipulation
            jointID = joint;
            
            % parse orientation confidence title and value
            [t,line] = strtok(line,'|');
            [tmp,line] = strtok(line,'|');
            oconf = str2num(tmp);
            oriConf(frame,userID,jointID) = oconf;
            
            % parse orientation title and value
            [t,line] = strtok(line,'|');
            ori = zeros(3);
            for o = 1:9
                [tmp,line] = strtok(line,'|');
                ori(o) = str2num(tmp);
            end
            oriMat(frame,userID,jointID,:,:) = ori;
            
            % parse position confidence title and value
            [t,line] = strtok(line,'|');
            [tmp,line] = strtok(line,'|');
            pconf = str2num(tmp);
            posConf(frame,userID,jointID) = pconf;
            
            % parse position title and value
            [t,line] = strtok(line,'|');
            pos = zeros(1,3);
            for p = 1:3
                [tmp,line] = strtok(line,'|');
                pos(p) = str2num(tmp);
            end
            posMat(frame,userID,jointID,:) = pos;
            
        end
    end

    line = fgetl(fid);
end
fclose(fid);
