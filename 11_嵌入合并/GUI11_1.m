
function GUI11_1()

Fig = figure('Position',[400,700,300,100],'menu','none');
Fig.Color = 'white';
Fig.NumberTitle = 'off';
Fig.Name = '��ҵ���GUI';

uicontrol(Fig,'style','pushbutton','String','�㷨������ʾ','Fontsize',16,...
    'Units','normalized','Position',[0,0,1,0.5],'Callback',@Doit1);
uicontrol(Fig,'style','pushbutton','String','�㷨Ч���Ա�','Fontsize',16,...
    'Units','normalized','Position',[0,0.5,1,0.5],'Callback',@Doit2);

H = [];

    function Doit1(~,~)
        delete(H)
        H = GUI1();
    end

    function Doit2(~,~)
        delete(H)
        H = GUI2();
    end

end




