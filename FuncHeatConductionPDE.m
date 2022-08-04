function sol = FuncHeatConductionPDE(kappa, c, rho, t_max, L, m, n)
% Show a temperature distribution in a bar in 1D (solved by pdepe)
    alpha = kappa / (c * rho);
    temperature = 1000; % 土蔵の外の温度
    xmesh = linspace(0, L, n+1); % 空間の区切り目
    tspan = linspace(0, t_max, m+1); % 時間の区切り目

    % 偏微分方程式を数値計算で解く
    sol = pdepe(0, @(x, t, u, dudx) pdefun(x, t, u, dudx, alpha), @icfun, @bcfun, xmesh, tspan);

    % t_max後の土蔵の温度分布のグラフ
    figure;
    imagesc(xmesh, [1], sol(m+1, :));
    colormap jet;
    colorbar();
    xlim([0, L]);
    xlabel("x");
    yticks({});
    yticklabels({});

    % 土塀の温度変化のグラフ
    figure;
    imagesc(tspan, xmesh, sol.');
    colormap jet;
    colorbar();
    ax = gca;
    ax.YDir = 'normal';
    ylim([0 L]);
    xlabel("t");
    ylabel("x");
end 