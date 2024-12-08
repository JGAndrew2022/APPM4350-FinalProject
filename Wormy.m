data = ExplicitPeristaltic_gm.main;
figure;
surf(data.xvals, data.tvals, data.u, 'edgecolor','interp')
xlabel("Body Segments of worm (x)")
ylabel("Time (t)")
zlabel("Displacment of Worm Segments (U)")

figure; 
scatter(reshape(data.u+data.xvals,[],1),reshape(repmat(data.tvals(:),[1 length(data.xvals)]),[],1),[],reshape(repmat(data.xvals,[length(data.tvals) 1]),[],1),'o','filled')
colorbar
ylim([0 10])
grid on
xlabel('Displacement of Worm Segments Plus its Position (U)')
ylabel('Time (t)')
title('Locations of Body Segments in Time')


%%
figure; plot(-.5:.001:.5, ExplicitPeristaltic_gm.friction(-.5:.001:.5))
ylabel('External Friction')
xlabel('Velocity')
grid on

%lambda = 2pi/k