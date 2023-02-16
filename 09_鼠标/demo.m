clear; close all; clc

GUI9()

function GUI9()

%% ����
Fig = figure('Position',[600,200,1000,750],'menu','none',...
    'Color','white','NumberTitle','off','Name','GUI9');
% �ص�
set(Fig,'WindowButtonDownFcn',@ButtonDown);
set(Fig,'WindowButtonUpFcn',@ButtonUp);
set(Fig,'WindowButtonMotionFcn',@ButtonMotion);
set(Fig,'WindowScrollWheelFcn',@ScrollWheel);
% ���
Pnl1 = uipanel(Fig,'Position',[0.05,0.05,0.7,0.9]);
Pnl2 = uipanel(Fig,'Position',[0.75,0.05,0.2,0.9]);
% ��ͼ��
Axes = axes(Pnl1,'Position',[0.1,0.1,0.8,0.8]);
axis([-1,1,-1,1]),grid on,hold on
% �ı���
str = '';
Text = uicontrol(Pnl2,'style','text',...
    'String',str,'Fontsize',16,...
    'Units','normalized','Position',[0.1,0.1,0.8,0.5]);
% ��ť��
Bt1 = uicontrol(Pnl2,'style','togglebutton',...
    'String','������Բ��','Fontsize',16,'BackgroundColor',[0.6,1,0.6],...
    'Unit','normalized','Position',[0,0.9,1,0.1],...
    'Callback',@Doit1);
Bt2 = uicontrol(Pnl2,'style','togglebutton',...
    'String','�޸�����Բ��','Fontsize',16,'BackgroundColor',[0.6,0.6,1],...
    'Unit','normalized','Position',[0,0.8,1,0.1],...
    'Callback',@Doit2);
Bt3 = uicontrol(Pnl2,'style','togglebutton',...
    'String','�������Բ��','Fontsize',16,'BackgroundColor',[1,0.6,0.6],...
    'Unit','normalized','Position',[0,0.7,1,0.1],...
    'Callback',@Doit3);

%% ��Ա
% ִ��ʲô����
task = 0;
state = 0;
tmp = [];% ����ʱ���
% ��¼���λ��
p1 = [];
p2 = [];
% Բ��Ϣ
circleInfo = []; % ��Բ�İ뾶
circleList = {}; % ����
circleNum = 0; % ����
circleIdx = 0; % ��ǰ��������
basicCircle = DrawCircle(); % �����ṹ

%% ��ť��
    function Doit1(~,~)
        if get(Bt1,'Value')
            set(Bt2,'Value',0)
            set(Bt3,'Value',0)
            task = 1;
            str = '��ȷ��Բ��λ��';
            set(Text,'String',str)
        else
            task = 0;
        end
    end

    function Doit2(~,~)
        if get(Bt2,'Value')
            set(Bt1,'Value',0)
            set(Bt3,'Value',0)
            task = 2;
            str = '��ѡ��Ҫ�޸ĵ�Բ';
            set(Text,'String',str)
        else
            task = 0;
        end
    end

    function Doit3(~,~)
        if get(Bt3,'Value')
            set(Bt1,'Value',0)
            set(Bt2,'Value',0)
            task = 3;
            str = '��ѡ��Ҫɾ����Բ';
            set(Text,'String',str)
        else
            task = 0;
        end
    end

%% �����
    function ButtonDown(~,~)
        cp = get(gca,'currentpoint');
        switch task
            case 1
                p1 = [cp(1,1),cp(1,2)];
                tmp = plot(p1(1),p1(2),'r.','Parent',Axes);
                state = 1;
            case 2
                if circleNum>0
                    p1 = [cp(1,1),cp(1,2)];
                    circleIdx = ChooseCircle(circleInfo,p1);
                    set(circleList{circleIdx},'LineStyle','--')
                    state = 1;
                end
            case 3
                if circleNum>0
                    p1 = [cp(1,1),cp(1,2)];
                    circleIdx = ChooseCircle(circleInfo,p1);
                    state = 1;
                end
        end
    end

    function ButtonUp(~,~)
        if state
            cp = get(gca,'currentpoint');
            switch task
                case 1
                    delete(tmp)
                    p2 = [cp(1,1),cp(1,2)];
                    R = norm(p1-p2);
                    [cx,cy] = Updata(basicCircle,[p1,R]);
                    h = plot(cx,cy,'LineWidth',5,'Parent',Axes);
                    
                    circleNum = circleNum+1;
                    circleIdx = circleNum;
                    circleInfo(circleNum,:) = [p1,R];
                    circleList{circleNum} = h;
                case 2
                    set(circleList{circleIdx},'LineStyle','-')
                case 3
                    delete(circleList{circleIdx})
                    circleList(circleIdx) = [];
                    circleInfo(circleIdx,:) = [];
                    circleNum = circleNum-1;
            end
            state = 0;
        end
    end

    function ButtonMotion(~,~)
        if task==2 && state
            cp = get(gca,'currentpoint');
            p2 = [cp(1,1),cp(1,2)];
            dp = p2-p1;
            if norm(dp)>0.01
                circleInfo(circleIdx,1:2) = circleInfo(circleIdx,1:2)+dp;
                [cx,cy] = Updata(basicCircle,circleInfo(circleIdx,:));
                circleList{circleIdx}.XData = cx;
                circleList{circleIdx}.YData = cy;
                p1 = p2;
            end
        end
    end

    function ScrollWheel(~,event)
        if task==2 
            cp = get(gca,'currentpoint');
            p2 = [cp(1,1),cp(1,2)];
            circleIdx = ChooseCircle(circleInfo,p2);
            
            value = event.VerticalScrollCount; % �ؼ���
            circleInfo(circleIdx,3) = max(circleInfo(circleIdx,3)+value*0.01,0.01);
            [cx,cy] = Updata(basicCircle,circleInfo(circleIdx,:));
            circleList{circleIdx}.XData = cx;
            circleList{circleIdx}.YData = cy;
            
        end
    end

%% �Ӻ���
% �������
    function idx = ChooseCircle(circleInfo,C)
        dis = sum((circleInfo(:,1:2)-C).^2,2);
        [~,idx] = min(dis);
    end

% ����Բ
    function [cx,cy] = Updata(basicCircle,w)
        cx = w(3)*basicCircle(:,1)+w(1);
        cy = w(3)*basicCircle(:,2)+w(2);
    end

% ����Բ��
    function out = DrawCircle()
        t = 0:pi/32:2*pi;
        cx = cos(t');
        cy = sin(t');
        out = [cx,cy];
    end

end

