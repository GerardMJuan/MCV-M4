function [ nonShadow ] = ShadowRemoval( frame, frame_B, mask, th, method )
% ShadowRemoval: Using thresholds on HSV space color it removes
% shadows from a foreground detection algorithm.
% IMPORTANT: Prepared to work in with RGB source images.

switch method
    case 'hsv'
        frame = rgb2hsv(frame);
        frame_B = rgb2hsv(frame_B);
        
        ratio_V = frame(:,:,3)./frame_B(:,:,3);
        dif_H = abs(frame(:,:,1)-frame_B(:,:,1));
        dif_S = abs(frame(:,:,2)-frame_B(:,:,2));
        
        shadow_mask = (ratio_V>=th.alpha)&(ratio_V<=th.beta)&(dif_H<=th.tH)&...
            (dif_S<=th.tS)&mask;
        
    case 'rg_s'
        
        s_im = frame(:,:,1)+frame(:,:,2)+frame(:,:,3);
        s_bg = frame_B(:,:,1)+frame_B(:,:,2)+frame_B(:,:,3);
        shadow_mask = (s_im./s_bg>=th.alpha)&(s_im./s_bg<=th.beta)&mask;
        
        
end

% subplot(2,2,3);
% imshow(shadow_mask);
% title('Shadow Mask')

nonShadow = (~shadow_mask)&mask;

end

