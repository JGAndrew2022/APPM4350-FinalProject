data = ExplicitPeristaltic_gm.main;
figure;
surf(data.xvals, data.tvals, data.u, 'edgecolor','interp')
xlabel("Body Segments of worm (x)")
ylabel("Time (t)")
zlabel("Displacment of Worm Segments (U)")

figure; 
scatter(reshape(data.u+data.xvals,[],1),reshape(repmat(data.tvals(:),[1 length(data.xvals)]),[],1),[],reshape(repmat(data.xvals,[length(data.tvals) 1]),[],1),'o','filled')
colorbar('Ticks',[0,0.5, 1],'TickLabels',{'Tail', 'Middle', 'Head'})
ylim([0 10])
grid on
xlabel('Displacement of Worm Segments Plus its Position (U)')
ylabel('Time (t)')
title('Locations of Body Segments in Time')

%%
figure; plot(-.1:.001:.1, ExplicitPeristaltic_gm.friction(-.1:.001:.1))
ylabel('External Friction')
xlabel('Velocity')
grid on
