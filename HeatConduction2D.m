%%% Show a temperature distribution in an iron plate in 2D
% Initialization
kappa = 48; % 熱伝導率
c = 461; % 比熱
rho = 7.28; % 密度
alpha = kappa / (c * rho);
L = 0.5; % 壁の厚さ * 2, 棒の長さ
t_max = 6; % 観測する時間
d = 0.01; % 時間刻み幅 dは十分小さくなければ解が発散する(体感として0.01以下ならうまくいく)
m = round(t_max/d); % 行列計算の回数
n = 30;
h = L/n; % 空間刻み幅
temperature = 25; % 境界の温度1
burner = 1800; % 境界の温度2
u = zeros( (n+1)^2, 1 ); % 空間の分割地点における温度
X = linspace(0, L, n+1);
Y = linspace(0, L, n+1);
mesh = zeros(n+1, n+1);

% 初期条件
for i = 1:n+1
    for j = 1:(n+1)
        cur = (n+1)*(i-1) + j;
        if i == 1 || j == 1 || i == n+1 || j == n+1
            u( cur ) = burner;
        else
            u( cur ) = temperature;
        end
    end
end

% 行列の構成
a = ( (2*(h^2)) / (d*alpha) );
Mat = zeros( (n-1)^2 );
for i = 1:n-1
    for j = 1:n-1
        cur = (n-1)*(i-1) + j;
        up = cur - (n-1);
        down = cur + (n-1);
        left = cur - 1;
        right = cur + 1;
        Mat( cur, cur ) = a+4;
        if i ~= 1
            Mat( cur, up ) = -1;
        end
        
        if i ~= n-1
            Mat( cur , down ) = -1;
        end
        
        if j ~= 1
            Mat( cur, left ) = -1;
        end
        
        if j ~= n-1
            Mat( cur, right ) = -1;
        end
    end
end
Mat = sparse(Mat);

% 行列演算
for k = 1:m
    b = zeros( (n-1)^2 , 1 );
    for i = 1:n-1
        for j = 1:n-1
            b_cur = (n-1)*(i-1) + j;
            u_cur = (n+1) * i + j+1;
            u_up = cur - (n+1);
            u_down = cur + (n+1);
            u_left = cur - 1;
            u_right = cur + 1;

            b( b_cur ) = (a-4) * ( u( u_cur ) ) + u( u_up ) + u( u_down ) + u( u_left ) + u( u_right );
            
            % Crank-Nicolson法の左辺に境界の温度を含むなら, 右辺に移項する
            if i == 1
                b( b_cur ) = b( b_cur ) + burner;
            end
            if i == n-1
                b( b_cur ) = b( b_cur ) + burner;
            end
            if j == 1
                b( b_cur ) = b( b_cur ) + burner;
            end
            if j == n-1
                b( b_cur ) = b( b_cur ) + burner;
            end
        end
    end
    
    % 連立一次方程式を解く
    temp = Mat\b;
    % 適切なuの成分にMat\bの解を割り当てる
    for i = 1:(n+1)
        for j = 1:(n+1)
            if i ~= 1 && i ~= n+1 && j ~= 1 && j ~= n+1
                u_cur = (n+1)*(i-1) + j;
                t_cur = (n-1)*(i-2) + j-1;
                u( u_cur ) = temp( t_cur );
            end
        end
    end
end

% メッシュの構成
for i = 1:((n+1)^2)
    y = floor( (i-1)/ (n+1) ) + 1;
    x = mod(i-1, n+1) + 1;
    mesh(y, x) = u(i);
end
% プロット
imagesc(X, Y, mesh);
caxis([0, burner]);
colorbar();
xlim([0, L]);
ylim([0, L]);