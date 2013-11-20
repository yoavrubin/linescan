
    function lsdBrowse_Callback(hObject, eventdata, handles)
global data usedPath
    [FileName,PathName] = uigetfile(strcat(usedPath,'*.tif'),'Select Line Scan Data File');
 %  ref = imread('C:\LineScan-12012008-1830-1263-Cycle001_Ch2Source.tif');
 
   FileName
    PathName 
  ref = imread(strcat(PathName,FileName));
   %[imageHandle, axHandle, figHandle] = imhandles(theAxis); 
    %imageHandle = imageHandle(1);
    %axHandle = axHandle(1);
    %cdata = get(imageHandle, 'CData');
    %imageRange = [double(min(cdata(:))) double(max(cdata(:)))];
    %set(axHandle,'Clim', imageRange);
    %imshow (ref)
      imagesc(ref)
    colormap('gray')
   
        if isequal(FileName,0)
        return;
    end
    
    
    
    