function u_series = FuncHeatConduction(kappa, c, rho, m, n)
% Show a temperature distribution in a bar in 1D (solved by Crank-Nicolson method)
    alpha = kappa / (c * rho);
    L = 1; % 壁の厚さ * 2, 棒の長さ
    t_max = 3600; % 観測する時間の長さ
    d = t_max/m; % 時間刻み幅
    h = L/n; % 空間刻み幅
    x = linspace(0, L, n+1); % 空間の各分割地点
    t = linspace(0, t_max, m+1); % 0からt_maxまでを分割した時の各時間
    temperature = 1000; % 土蔵の外の温度
    u = zeros(n+1, 1); % 空間の分割地点における温度
    u(1) = temperature; % 左側境界条件
    u(n+1) = temperature; % 右側境界条件
    u_series = zeros(m+1, n+1); % 各時点におけるu
    u_series(1, :) = u(:);

    % Crank-Nicolson公式の左辺を行列で構成
    a = ( (2*h^2) / (d * alpha)) + 2;
    Mat = zeros(n-1);
    for j = 1:n-1
        Mat(j, j) = a;
        if j > 1
            Mat(j, j-1) = -1;
        end
        if j < n-1
            Mat(j, j+1) = -1;
        end
    end

    % 行列演算による求解
    for i = 1:m
        b = zeros(n-1, 1); % Crank-Nicolson公式の右辺
        for j = 1:n-1
            b(j) = u(j+2) + (a-4) * u(j+1) + u(j);
        end
        b(1) = b(1) + temperature;
        b(n-1) = b(n-1) + temperature;
        u(2:n) = Mat\b;
        u_series(i+1, :) = u(:);
    end

    % t_max秒後の土塀の温度分布のグラフ
    figure;
    imagesc(x, [1], u.');
    colormap jet;
    colorbar();
    xlim([0, L]);
    xlabel("x");
    yticks({});
    yticklabels({});

    % 土塀の温度変化のグラフ
    figure;
    imagesc(t, x, u_series.');
    ax = gca;
    colormap jet;
    colorbar();
    ax.YDir = 'normal';
    ylim([0 L]);
    xlabel("t");
    ylabel("x");
end