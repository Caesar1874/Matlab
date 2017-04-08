function RewardTEST(subName, subGender, oprMode, rewardSetting, keySetting)

if nargin < 5
    subName = 'Test';
    subGender = '999';
    oprMode = 'test';
    rewardSetting = 1;
    keySetting = 1; 
end 

try 
%% 开启屏幕    
    backgroundColor = [150 150 150];
    foreColor = [0 0 0];
    testColor = [255 255 255];
    Screen('Preference', 'SkipSyncTests', 1);
    [window, screenRect] = Screen('OpenWindow', 0, backgroundColor);
    physicalFrameRate = Screen('FrameRate', window);
    [screenCenter(1), screenCenter(2)] = RectCenter(screenRect);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    HideCursor;
    %字体
    olds=Screen('TextSize',window,28);
    Screen('TextFont',window,'Microsoft Yahei');
    
%% 生成实验条件
    % trial数
    nTrials = 1296;
    thirdTrials=nTrials / 3;
    
    % 条件数
    nConditions = 1296;  
    
%%new start
    % 0: noReward, 1: high reward, 2: lowreward
    trialRewardLevel = Shuffle(repmat([0, 1, 2], 1, nTrials / 3));
    
    % 0: 无效， 1： 有效
    trialCueValidate = Shuffle(repmat([0, 1], 1, nTrials / 2));
    
    % 2 / (3*6)
    trialRewardPos = Shuffle(repmat([1, 2, 3, 4, 5, 6], 1, nTrials / 9));
    
    %
    trialCuePos = Shuffle(repmat([1, 2, 3, 4, 5, 6], 1, nTrials / 6));
    
    % 在 cuePos 上随机递增, 50% 的trial 使用testPos, 50%使用 cuePos，即有效性50%
    trialTestPos = Shuffle(repmat([1, 2, 3, 4, 5], 1, nTrials / 10))
%% new end
    
    
    
    
    %无奖励
    nonRewardCondition = zeros(thirdTrials,6);
    %高奖励
    highRewardCondition = zeros(thirdTrials,6);
    %低奖励
    lowRewardCondition = zeros(thirdTrials,6);
    for i=1:thirdTrials
        nonRewardCondition(i,:) = randperm(6);
        highRewardCondition(i,:) = randperm(6);
        lowRewardCondition(i,:) = randperm(6);
    end
    
    % cueType
    nBlocks = 16;
    blockLength = 81;
    blockPoints = zeros(1, nBlocks);
    for index = 1 : nBlocks
        blockPoints(index) = (index - 1) * blockLength + 1;
    end
    blockTypes = ones(1, nBlocks);
    blockTypes(1, 1 : nBlocks / 2) = 2;
    blockTypes = Shuffle(blockTypes);
    cueTypesMat = repmat(blockTypes', 1, blockLength);
    trialCueTypes = reshape(cueTypesMat', 1, nTrials);
   
    %随机条件
%      trialCondition = ShiftMod(randperm(nTrials), nConditions);%(1 ~ 1296)  
%         trialTestPosition=ceil(trialCondition / 108); % 1-12
%         % 1 ~ 6 表示重复，7表示新异刺激，各占一半
%         trialTestPosition( trialTestPosition > 6 ) = 7;
%      
%      trialCondition = ShiftMod(trialCondition, 108); % 1 ~ 108
%         trialRewardPosition=ceil(trialCondition / 12); % 1 ~ 9
%         % 1 ~ 6 表示 6 个rewardPos, 7 表示 无奖励，占 1 / 3
%         trialRewardPosition(trialRewardPosition > 6) = 7;
%      
%     trialCondition = ShiftMod(trialCondition, 12); % 1 ~ 12
%     trialCuePosition = ceil(trialCondition / 2); % 1 - 6
%      
%      trialCondition = ShiftMod(trialCondition, 2);% 1 - 2
%         trialRewardLevel=trialCondition;
%         trialRewardLevel(trialRewardPosition > 6) = 0;
%     
%     trialCueValid = zeros(1, nTrials);
%     trialCueValid(trialTestPosition == trialCuePosition) = 1;
    

%% 读取图片
    % 指导语
    greetingTex = Screen('MakeTexture', window, ceil(imread('material\start.bmp')));
    errorTex = Screen('MakeTexture', window, ceil(imread('material\error.png', 'BackGround', backgroundColor/255)));
    correctTex = Screen('MakeTexture', window, ceil(imread('material\correct.png', 'BackGround', backgroundColor/255)));
    restTex = Screen('MakeTexture', window, ceil(imread('material\rest.png')));
    endTex = Screen('MakeTexture', window, ceil(imread('material\ending.png')));

    % 刺激材料
    mapTex = zeros([1 6]);
    imgNum = 10;
    for texIndex = 1:imgNum
        [im, imMap, imAlpha] = imread(['stimuli\m', num2str(texIndex), '.png']);
        im(:, :, 4) = imAlpha;
        mapTex(1, texIndex) = Screen('MakeTexture', window, im);  
    end

    [im, imMap, imAlpha] = imread('stimuli\arrow.png')
    im(:, :, 4) = imAlpha;
    barTex = Screen('MakeTexture', window, im);
    [im, imMap, imAlpha] = imread('stimuli\target.png')
    im(:, :, 4) = imAlpha;
    targetTex = Screen('MakeTexture', window, im);     
    
%% 定义按键反应
    KbName('UnifyKeyNames');
    if keySetting == 1
        keyF = KbName('LEFTARROW');% yes
        keyJ = KbName('RIGHTARROW');% no
    else
        keyF = KbName('RIGHTARROW');% yes
        keyJ = KbName('LEFTARROW');% no
    end
    keyESC = KbName('ESCAPE');
    
%% 刺激呈现参数
    % 颜色
    % 8 种
    red=[255 0 0];
    green=[0 255 0];
    blue=[0 0 255];
    yellow=[255 255 0];
    cyan=[0 255 255];
    purple=[255 0 255];
    black=[0 0 0];
    pink = [255, 204, 204];
    % 非奖励联结颜色
    nonRewardColorSet=[blue; yellow; cyan; black; pink; purple]; 
    %奖励联结颜色
    if rewardSetting==1
        highRewardColor=red;
        lowRewardColor=green;
    elseif rewardSetting==2
        highRewardColor=green;
        lowRewardColor=red;
    end
    
    % 位置
    % 大圆的半径 小圆圆心到注视点
    radius = 110; 
    %小圆的半径
    sectionRadius = 45; %45 小圆的半径 bar的一半
    
    % 小圆圆心的坐标
    sections=cell([1 6]);
    sections{1} = [screenCenter(1)+radius*cos(11*pi/6),screenCenter(2)+radius*sin(11*pi/6)];
    sections{2 }=[screenCenter(1)+radius*cos(3*pi/2),screenCenter(2)+radius*sin(3*pi/2)];
    sections{3}=[screenCenter(1)+radius*cos(7*pi/6),screenCenter(2)+radius*sin(7*pi/6)];
    sections{4}=[screenCenter(1)+radius*cos(5*pi/6),screenCenter(2)+radius*sin(5*pi/6)];
    sections{5}= [screenCenter(1)+radius*cos(pi/2),screenCenter(2)+radius*sin(pi/2)];
    sections{6}= [screenCenter(1)+radius*cos(pi/6),screenCenter(2)+radius*sin(pi/6)];
    
    %小圆轮廓坐标
    row1 = [sections{1}(1)-sectionRadius,sections{1}(2)-sectionRadius,sections{1}(1)+sectionRadius,sections{1}(2)+sectionRadius];
    row2 = [sections{2}(1)-sectionRadius,sections{2}(2)-sectionRadius,sections{2}(1)+sectionRadius,sections{2}(2)+sectionRadius];
    row3 = [sections{3}(1)-sectionRadius,sections{3}(2)-sectionRadius,sections{3}(1)+sectionRadius,sections{3}(2)+sectionRadius];
    row4 = [sections{4}(1)-sectionRadius,sections{4}(2)-sectionRadius,sections{4}(1)+sectionRadius,sections{4}(2)+sectionRadius];
    row5 = [sections{5}(1)-sectionRadius,sections{5}(2)-sectionRadius,sections{5}(1)+sectionRadius,sections{5}(2)+sectionRadius]; 
    row6 = [sections{6}(1)-sectionRadius,sections{6}(2)-sectionRadius,sections{6}(1)+sectionRadius,sections{6}(2)+sectionRadius];
    % 6 * 4， 使用时应该转置
    sectionRects = [row1; row2; row3; row4; row5; row6];
   
    % 检测项
    mapSize = 150; 
    topLeft=[screenCenter(1)-mapSize/2, screenCenter(2)-mapSize/2];
    topRight=[screenCenter(1)+mapSize/2, screenCenter(2)-mapSize/2];
    bottomRight=[screenCenter(1)+mapSize/2, screenCenter(2)+mapSize/2];
    bottomLeft=[screenCenter(1)-mapSize/2, screenCenter(2)+mapSize/2];
    
    %注视点
    fixSize = [15 2]*2;
    fixRects = [CenterRect([0 0 fixSize], screenRect); ...
                CenterRect([0 0 fliplr(fixSize)], screenRect)];
    
    % 时间
    trialInterval = rand([1 nTrials]) * 0.5 + 1;
    fixDuration = (400 + 200 * rand([1 nTrials])) / 1000;
    % 刺激呈现时间
    stimuliDuration = 1000 / 1000; 
    beforeCueDuration = 100 / 1000;
    cueDuration = 200 / 1000;
    beforeTestDuration = 1000 / 1000;
    testFixDuration = 1000 / 1000; 
    RTLimit = 3000 / 1000;
    feedDuration = 500 / 1000;
    
%% 变量
    answer = zeros([1 nTrials]);
    answerCorrect = zeros([1 nTrials]);
    RT = zeros([1, nTrials]);
    % 各条件计数
    nonRewardIndex = 1;
    highRewardIndex = 1;
    lowRewardIndex = 1;
    
    rewardIndex = 1;
    cueValidIndex = 1;
  
%% 开始实验
    % 准备
     Screen('DrawTexture', window, greetingTex);
     keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
         [keyisdown,secs,keycode] = KbCheck;
         WaitSecs(0.001); % delay to prevent CPU hogging
    end
    Screen('Flip', window);
    KbWait;
    isRunning = true;
    keyOperation = false;
    
    % 进入实验   
    for trialIndex = 1: 10 %nTrials
        %初始化参数
        block = find(blockPoints == trialIndex);
        if block > 0
            cueType = blockTypes(1, block);
        end
          
        currentColorSet=zeros(6,3);
        texOrder = randperm(imgNum);
        
        Screen('Flip', window);
        WaitSecs(trialInterval(trialIndex));
        % 呈现注视点
        Screen('FillRect', window, foreColor, fixRects');
        Screen('Flip', window);
        WaitSecs(fixDuration(trialIndex));
        
        if trialRewardLevel(trialIndex) == 0
            Screen('DrawText', window, '无奖励')
			%呈现刺激
			% 同时绘制六个颜色 + 六个透明形状
			for positionIndex = 1 : 6
				Screen('FillRect', window, nonRewardColorSet(positionIndex, : ), sectionRects(positionIndex, : ));
				Screen('DrawTexture', window, mapTex(1, texOrder(positionIndex)), [], sectionRects(positionIndex, : ));
			end
			Screen('Flip', window);
			WaitSecs(stimuliDuration);
            Screen('Flip', window);
            WaitSecs(beforeCueDuration);
			
			% cue
            if cueType == 1 
                arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];
            
                rotationAngle = 60 * trialCuePos(trialIndex);
                Screen('DrawTexture', window, barTex, [], arrowCuePos, rotationAngle);
            else
                squareCuePos = sectionRects(trialCuePosition(trialIndex), :);
                Screen('DrawTexture', window, targetTex, [], squareCuePos);
            end
			Screen('Flip', window);
			WaitSecs(cueDuration);
            Screen('Flip', window);
            WaitSecs(beforeTestDuration);

		   %检测
           if trialCueValidate(trialIndex) == 1 
              testPos =  trialCuePosition(trialIndex);
           else
              testPos = trialTestPosition(cueValidIndex);
              cueValidIndex ++;
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           Screen('FillRect', window, foreColor, fixRects');
           Screen('Flip', window);
           WaitSecs(testFixDuration);	
           Screen('FillRect', window, testColor , [topLeft,bottomRight]);
           Screen('DrawTexture', window, mapTex(texOrder(testPos)), [], [topLeft,bottomRight]); 
           Screen('Flip', window);
           
		   nonRewardIndex = nonRewardIndex + 1;
        elseif trialRewardPosition(trialIndex) < 7
            if trialRewardLevel(trialIndex) == 1
                Screen('DrawText', window, '高奖励')
                %高奖励
				%呈现
				for positionIndex=1:6
					if positionIndex == trialRewardPosition(trialIndex)
					   currentColor = highRewardColor; % 颜色
					else
						currentColor=nonRewardColorSet(highRewardCondition(highRewardIndex,positionIndex), : ); 
					end
					
					% 颜色
					Screen('FillRect', window, currentColor, sectionRects(positionIndex, : ));
					% 形状
					Screen('DrawTexture', window, mapTex(texOrder(positionIndex)), [], sectionRects(positionIndex, : )); 
					currentColorSet(positionIndex,:)=currentColor;
				end
				Screen('Flip', window);
				WaitSecs(stimuliDuration);
                Screen('Flip', window);
                WaitSecs(beforeCueDuration);

               % cue 
                if cueType == 1 
                    arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];

                rotationAngle = 60 * trialCuePosition(trialIndex)
                    Screen('DrawTexture', window, barTex, [], arrowCuePos, rotationAngle);
                else
                    squareCuePos = sectionRects(trialCuePos(trialIndex), :);
                    Screen('DrawTexture', window, targetTex, [], squareCuePos);
                end
                Screen('Flip', window);
                WaitSecs(cueDuration);
                Screen('Flip', window);
                WaitSecs(beforeTestDuration);

                
				%检测
				Screen('FillRect', window, foreColor, fixRects');
				Screen('Flip', window);
				WaitSecs(testFixDuration);	
				Screen('FillRect', window, testColor , [topLeft,bottomRight]);
				Screen('DrawTexture', window, mapTex(texOrder( trialTestPosition(trialIndex))), [], [topLeft,bottomRight]); 
				Screen('Flip', window);
				
				highRewardIndex=highRewardIndex+1;
            elseif trialRewardLevel(trialIndex) == 2
                Screen('DrawText', window, '低奖励')
				%呈现
				for positionIndex=1:6
					if positionIndex==trialRewardPosition(trialIndex)
					   currentColor=lowRewardColor; % 颜色
                    else   
					   currentColor=nonRewardColorSet(lowRewardCondition(lowRewardIndex,positionIndex),: ); 
					end
					% 颜色
					Screen('FillRect', window, currentColor, sectionRects(positionIndex, : ));
					% 形状
					% map  只有六个形状，肯定是不行的
					Screen('DrawTexture', window, mapTex(texOrder(positionIndex)), [], sectionRects(positionIndex, : ));  
					currentColorSet(positionIndex,:)=currentColor;
					
				end
				Screen('Flip', window);
				WaitSecs(stimuliDuration);
                Screen('Flip', window);
                WaitSecs(beforeCueDuration);
                
				% cue 
                if cueType == 1 
                    arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];

                rotationAngle = 60 * trialCuePosition(trialIndex)
                    Screen('DrawTexture', window, barTex, [], arrowCuePos, rotationAngle);
                else
                    squareCuePos = sectionRects(trialCuePos(trialIndex), :);
                    Screen('DrawTexture', window, targetTex, [], squareCuePos);
                end
                Screen('Flip', window);
                WaitSecs(cueDuration);
                Screen('Flip', window);
                WaitSecs(beforeTestDuration);

				%检测
				Screen('FillRect', window, foreColor, fixRects');
				Screen('Flip', window);
				WaitSecs(testFixDuration);	
				Screen('FillRect', window, testColor , [topLeft,bottomRight]);
				Screen('DrawTexture', window, mapTex(texOrder( trialTestPosition(trialIndex))), [], [topLeft,bottomRight]); 
				Screen('Flip', window);
				
				lowRewardIndex=lowRewardIndex+1;
            end
            rewardIndex=rewardIndex + 1;
        end

        % 收集反应
        startTime = GetSecs;
        while GetSecs - startTime < RTLimit
            [keyDown, keyTime, keyState] = KbCheck();
            if keyDown
                if keyState(keyESC)
                    isRunning = false;
                    break;
                elseif keyState(keyF)
                    answer(trialIndex) = 1;%按键表示yes
                    RT(trialIndex) = round(1000*(keyTime - startTime));
                    break;
                elseif keyState(keyJ)
                    answer(trialIndex) = 2;%按键表示no
                    RT(trialIndex) = round(1000*(keyTime - startTime));
                    break;
                end            
            end
        end
        Screen('Flip', window);
        
        if ~isRunning
            break;
        else
            %if ~strcmpi(oprMode, 'normal') 
                if (answer(trialIndex)== 1 && trialTestPosition(trialIndex)<5 ) || (answer(trialIndex)== 2 && trialTestPosition(trialIndex)>4 )
                    answerCorrect(trialIndex) = 1;
                    if ~strcmpi(oprMode, 'normal')
                    Screen('DrawTexture', window, correctTex);
                    end
                else 
                    answerCorrect(trialIndex) = 2;  
                    if ~strcmpi(oprMode, 'normal')
                    Screen('DrawTexture', window, errorTex);
                    end
                end
          
            % 练习 反馈
            Screen('Flip', window);
            WaitSecs(feedDuration);
        end
        
        %休息
        if ismember(trialIndex,[96, 192, 288, 384, 480, 576, 672, 768, 864, 960, 1056]) %96
            Screen('TextColor',window,[0,0,0]);
            Screen('DrawTexture', window, restTex);
%            DrawFormattedText(window, ['请休息几分钟！如果休息好了请按任意键继续实验~'], 'center', screenRect(4) / 2 + 20 ); 
           Screen('Flip', window); 
           Screen('TextColor',window,[227,23,13]);
           keyisdown = 1;
           while(keyisdown) % first wait until all keys are released
                     [keyisdown, secs, keycode] = KbCheck;
                     WaitSecs(0.001); % delay to prevent CPU hogging
          end
          KbWait;
        end
    end
    
    
    % 保存数据
    currentTime = datestr(now);
    currentTime(currentTime == ':') = '-';
    
    save(strcat('results\Test\', subName));

    expData = num2cell([(1:nTrials)', trialRewardLevel', trialRewardPosition', trialCueTypes', trialCuePosition', trialTestPosition', trialCueValid', RT', answer', answerCorrect']);
    result = [{'subName', 'subGender', 'KeySetting', 'RewardSetting', 'Trial',...
                                      'RewardLevel',  'RewardPosition', 'CueType', 'CuePosition', 'TestPosition',  'CueValid', 'RT', 'answer', 'answerCorrect'}; ...
              repmat({subName}, [nTrials 1]), repmat({subGender}, [nTrials 1]), repmat({rewardSetting}, [nTrials 1]), repmat({keySetting}, [nTrials 1]), expData];

    save(strcat('results\Test\MAT_', subName), 'result');
    
    if strcmpi(oprMode, 'normal')
        xlswrite(strcat('results\Test\Result_', currentTime, '_', subName, '.xls'), result);  
    else
        xlswrite(strcat('results\Test\Result_', currentTime, '_', subName, '_Practice.xls'), result);
    end
    %结束
%     Screen('TextColor',window,[0,0,0]);
    Screen('DrawTexture', window, endTex);
    DrawFormattedText(window, [num2str(Sample([0.73, 0.75, 0.74, 0.76, 0.77]))], screenRect(3) / 2, screenRect(4) / 2 - 65 ); 
    
%     DrawFormattedText(window, ['请不要进行任何操作并联系主试，谢谢合作'], 'center', screenRect(4) / 2 + 30 ); 
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
         [keyisdown,secs,keycode] = KbCheck;
         WaitSecs(0.001); % delay to prevent CPU hogging
    end
    Screen('Flip', window);
    KbWait; 
    
    Screen('CloseAll');
    
catch err
    Screen('CloseAll');
    rethrow(err); 
    
end