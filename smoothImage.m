function smoothImage(smoothingPixels)
global data
    [isUsingNW isUsingN isUsingNE isUsingW isUsingE isUsingSW isUsingS isUsingSE] = performSmoothing(smoothingPixels);
    fileName = strcat(data.files.lsdPath,'imageSetup.imageSetup');
    fid = fopen(fileName,'a');   
    fprintf(fid,'smoothing=%d %d %d %d %d %d %d %d\n', [isUsingNW isUsingN isUsingNE isUsingW isUsingE isUsingSW isUsingS isUsingSE]);
    fclose(fid);