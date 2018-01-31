if ~exist('s','var')
    s = serial('/dev/ttyUSB0');
    set(s,'BaudRate', 9600);
end

if s.status(1) == 'c'
    fopen(s);
end
pause(2)

x = [0 0 5 2];
y = [5 10 7.5 6];
z = [0 0 0 6];
r = 7;

z1 = z(4) + sqrt(r^2 - (x(1) - x(4))^2 - (y(1) - y(4))^2);
z2 = z(4) + sqrt(r^2 - (x(2) - x(4))^2 - (y(2) - y(4))^2);
z3 = z(4) + sqrt(r^2 - (x(3) - x(4))^2 - (y(3) - y(4))^2);

zk = [z1 z2 z3];

line([x(1) x(1)], [y(1) y(1)], [z(1) 20])
line([x(2) x(2)], [y(2) y(2)], [z(2) 20])
line([x(3) x(3)], [y(3) y(3)], [z(3) 20])

line([x(1) x(3)], [y(1) y(3)], [z(1) z(3)])
line([x(3) x(2)], [y(3) y(2)], [z(3) z(2)])
line([x(1) x(2)], [y(1) y(2)], [z(1) z(2)])

line([x(1) x(3)], [y(1) y(3)], [z(1)+20 z(3)+20])
line([x(3) x(2)], [y(3) y(2)], [z(3)+20 z(2)+20])
line([x(1) x(2)], [y(1) y(2)], [z(1)+20 z(2)+20])

arm1 = line([x(1) x(4)], [y(1) y(4)], [z1 z(4)]);
arm2 = line([x(2) x(4)], [y(2) y(4)], [z2 z(4)]);
arm3 = line([x(3) x(4)], [y(3) y(4)], [z3 z(4)]);

view(45,45)
xlabel('X')
ylabel('Y')
zlabel('Z')

for t = 0:0.1:30
    x(4) = sin(t) + 2;
    y(4) = cos(t) + 7.5;
    z(4) = 0.3*t;
    
    z1 = z(4) + sqrt(r^2 - (x(1) - x(4))^2 - (y(1) - y(4))^2);
    z2 = z(4) + sqrt(r^2 - (x(2) - x(4))^2 - (y(2) - y(4))^2);
    z3 = z(4) + sqrt(r^2 - (x(3) - x(4))^2 - (y(3) - y(4))^2);
    
    set(arm1, 'XData', [x(1) x(4)], 'YData', [y(1) y(4)], 'ZData', [z1 z(4)]);
    set(arm2, 'XData', [x(2) x(4)], 'YData', [y(2) y(4)], 'ZData', [z2 z(4)]);
    set(arm3, 'XData', [x(3) x(4)], 'YData', [y(3) y(4)], 'ZData', [z3 z(4)]);
    axis equal
    
    if t>0
        krokiZ1=-round((z1_old-z1)*1000);
        krokiZ2=-round((z2_old-z2)*1000);
        krokiZ3=-round((z3_old-z3)*1000);
        iksde = ['x' num2str(krokiZ1) 'y' num2str(krokiZ2) 'z' num2str(krokiZ3)];
        fprintf(s,iksde)
        
        while s.BytesAvailable<1
        end
        
        while s.BytesAvailable>0
            fscanf(s)
        end
    end
    z1_old=z1;
    z2_old=z2;
    z3_old=z3;
end