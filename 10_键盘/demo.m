clear; close all; clc

GUI10();

function GUI10()

%% ����
Fig = figure('Position',[600,500,1000,500],'menu','none',...
    'Color','white','NumberTitle','off','Name','GUI10');
set(Fig,'WindowKeyPressFcn',@KeyDown);
set(Fig,'WindowKeyReleaseFcn',@KeyUp);

% ��ͼ��
Axes = axes(Fig,'Position',[0.1,0.1,0.8,0.8]);
axis(10*[-1,1,0,1]),grid on,hold on
plot([-20,20],[0,0],'k-','LineWidth',3,'Parent',Axes);

% ��ʼ��
state = 0;
r = 1;
cir = DrawCircle(r);
p = [0,r];      % ��ǰλ��
v = [0,0];      % ��ǰ�ٶ�
dv = [5,10];    % �ٶȸı�ֵ
a = [0,0];      % ��ǰ���ٶ�
da = [-5,-20];  % ���ٶȸı�ֵ
H = plot(cir(:,1)+p(1),cir(:,2)+p(2),'r-','LineWidth',3,'Parent',Axes);
drawnow

%% ִ��
dt = 0.01;
t = zeros(2,2);
while 1
   
    if isvalid(Axes)
        xalim = get(Axes,'xlim');
        yalim = get(Axes,'ylim');
    else
        break
    end

     if state
        % �ٶȼ��
        tmp = v;
        v = v+a*dt;
        if (tmp(1)*v(1))<=0
            v(1) = 0;
        end
        % �����ײ���
        p = p+v*dt;
        if p(2)<r
            p(2) = r;
            v(2) = 0;
        end
        if norm(v)==0
            state = 0;
        end
        H.XData = cir(:,1)+p(1);
        H.YData = cir(:,2)+p(2);
     end
    
    drawnow
end


    function KeyDown(~,~)
        pt = get(gcf,'CurrentCharacter');
        if strcmpi(pt,'a') % ��
            v(1) = -dv(1);
            a(1) = -da(1);
            state = 1;
        end
        if strcmpi(pt,'d') % ��
            v(1) = dv(1);
            a(1) = da(1);
            state = 1;
        end
        if strcmpi(pt,'w') % ��
            v(2) = dv(2);
            a(2) = da(2);
            state = 1;
        end
    end

    function KeyUp(~,~)
        pt = get(gcf,'CurrentCharacter');
        if strcmpi(pt,'a') % ��
            if t(1,1)==0
                t(1,1) = now;
            else
                t(1,2) = now;
                if (t(1,2)-t(1,1))*86400<0.5
                    p(1) = p(1)-dv(1)*0.5;
                    t(1,1) = 0;
                else
                    t(1,1) = t(1,2);
                end
            end
        end
        
        if strcmpi(pt,'d') % ��
            if t(2,1)==0
                t(2,1) = now;
            else
                t(2,2) = now;
                if (t(2,2)-t(2,1))*86400<0.5
                    p(1) = p(1)+dv(1)*0.5;
                    t(2,1) = 0;
                else
                    t(2,1) = t(2,2);
                end
            end
        end
        
    end

    function out = DrawCircle(r)
        t = 0:pi/16:2*pi;
        cx = r*cos(t');
        cy = r*sin(t');
        out = [cx,cy];
    end

end

