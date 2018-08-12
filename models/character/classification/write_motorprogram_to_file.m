% input M: MotorProgram, file_name: File to write
function write_motorprogram_to_file(M,file_name)
fileID = fopen(file_name,'w');
% fprintf(fileID,'# the values of the parameters of the motor program\n');
list_sid=1:M.ns;
fprintf(fileID,'%10d\n',M.ns);
for i=list_sid
    stk=M.S{i};
    % fprintf(fileID,'start_location\n');    
    nn = numel(stk.invscales_token);
    fprintf(fileID,'%10d\n',nn);
    fprintf(fileID,'%10.4f %10.4f\n',stk.pos_token);
    for j=1:nn;
        % fprintf(fileID,'sub-stroke_scale\n');
        fprintf(fileID,'%10.4f\n',stk.invscales_token(j));
        % fprintf(fileID,'sub-stroke_controls\n');
        fprintf(fileID,'%10.4f %10.4f\n',stk.shapes_token(:,:,j)');
    end
end
fclose(fileID);
end