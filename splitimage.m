function splitimage(directorythatyouwanttosave,h,zoomvalu,mycentroids,IMplot)
% function splitimage(h,zoomvalu,mycentroids,IMplot)

[cn,cm]=size(mycentroids);
[maxY,maxX,heshzat]=size(IMplot);
for i= 1:cn
    xCTC=mycentroids(i,1);
    yCTC=mycentroids(i,2);
     imagename = [directorythatyouwanttosave '\spot' num2str(i) '.tif'];
%          imagename = [num2str(i) '.tif'];

    if xCTC>zoomvalu && yCTC > zoomvalu && maxY-yCTC>zoomvalu && maxX-xCTC>zoomvalu
        %plot(xCTC,yCTC,'w*')
        mysection = (IMplot(yCTC-h:yCTC+h,xCTC-h:xCTC+h,:));
        imwrite(mysection,imagename);
    end
    
    % North Center
    if yCTC<zoomvalu && maxX-xCTC>zoomvalu  && xCTC >zoomvalu
        % plot(xCTC,yCTC,'w*')
        mysection = (IMplot(1:yCTC+h,xCTC-h:xCTC+h, :));
        imwrite(mysection,imagename);
        
    end
    % NorthWest
    if yCTC<zoomvalu && xCTC <zoomvalu
        %         plot(xCTC,yCTC,'w*')
        imwrite(IMplot(1:yCTC+h, 1:  xCTC+h,:),imagename);
    end
    % NorthEast
    if yCTC<zoomvalu && maxX-xCTC<zoomvalu
        %         plot(xCTC,yCTC,'w*')
        mysection = (IMplot(1:yCTC+h,xCTC-h:maxX, :));
        imwrite(mysection,imagename);
    end
    %  West Center
    if xCTC<zoomvalu && maxY-yCTC > zoomvalu && yCTC>zoomvalu
        %     plot(xCTC,yCTC,'w*')
        
        mysection = (IMplot(yCTC-h:yCTC+h, 1:xCTC+h,:));
        imwrite(mysection,imagename);
    end
    
    % SouthWest
    if xCTC<zoomvalu && maxY-yCTC < zoomvalu
        %     plot(xCTC,yCTC,'w*')
        mysection = (IMplot(yCTC-h:maxY, 1:xCTC+h,:));
        imwrite(mysection,imagename);
    end
    % South Center
    if maxY-yCTC<zoomvalu && xCTC>zoomvalu && maxX-xCTC>zoomvalu
        %     plot(xCTC,yCTC,'w*')
        mysection = (IMplot(yCTC-h:maxY,xCTC-h:xCTC+h, :));
        imwrite(mysection,imagename);
    end
    % South east
    if maxY-yCTC<zoomvalu &&  maxX-xCTC<zoomvalu
        %     plot(xCTC,yCTC,'w*')
        mysection = (IMplot(yCTC-h:maxY, xCTC-h:maxX,:));
        imwrite(mysection,imagename);
    end
    % East Center
    if maxX-xCTC < zoomvalu && yCTC>zoomvalu & maxY-yCTC > zoomvalu
        %     plot(xCTC,yCTC,'w*')
        mysection = (IMplot(yCTC-h:yCTC+h, xCTC-h:maxX,:));
        imwrite(mysection,imagename);
        
    end
    
    
end
