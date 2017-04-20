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
    nTrials = 480;
    thirdTrials = nTrials / 3;
    nPos = 4;
%%new start
    rewardLevel = 2;
    rewardPos = nPos / rewardLevel * 3;
    nRewardCondition = rewardLevel * rewardPos;
    rewardCondition = ShiftMod(randperm(nTrials), nRewardCondition); % 1 ~ 12
    % 1-4: 奖励， 5~6 无奖励
    trialRewardPos = ceil(rewardCondition / rewardLevel); 
    trialRewardPos(trialRewardPos > nPos) = 0;
    % 0: noReward, 1: high reward, 2: lowreward
    trialRewardLevel = ShiftMod(rewardCondition, rewardLevel); % 1-2
    trialRewardLevel(trialRewardPos == 0) = 0;

    
    testPos = nPos * 2;
    cuePos = nPos;
    nCueCondition = testPos * cuePos;
    cueCondition = ShiftMod(randperm(nTrials), nCueCondition); % 1~72
    % 1~4 5~8
    trialTestPos = ceil(cueCondition / cuePos);
    trialCuePos = ShiftMod(cueCondition, cuePos);
%     for index = 1 : nTrials
%        if(trialTestPos(index) < 5)
%           trialTestPos(index) = trialCuePos(index); 
%        end
%     end
    trialCueValidate = zeros(1,nTrials);
    trialCueValidate(trialTestPos == trialCuePos) = 1;
    
    trialRewardValidate = zeros(1, nTrials);
    trialRewardValidate(trialRewardPos == trialCuePos) = 1;
    
    
    % cueType
    nBlocks = 10;
    blockLength = nTrials / nBlocks;
    blockPoints = zeros(1, nBlocks);
    for index = 1 : nBlocks
        blockPoints(index) = (index - 1) * blockLength + 1;
    end
    blockTypes = ones(1, nBlocks);
    blockTypes(1, 1 : nBlocks / 2) = 2;
    blockTypes = Shuffle(blockTypes);
    cueTypesMat = repmat(blockTypes', 1, blockLength);
    trialCueTypes = reshape(cueTypesMat', 1, nTrials);
    
    % 0: 无效， 1： 有效
    % trialCueValidate = Shuffle(repmat([0, 1], 1, nTrials / 2));
    % trialCuePos = Shuffle(repmat([1, 2, 3, 4, 5, 6], 1, nTrials / 6));
    % 0: noReward, 1: high reward, 2: lowreward
    % trialRewardLevel = Shuffle(repmat([0, 1, 2], 1, nTrials / 3));
    % 在 cuePos 上随机递增, 50% 的trial 使用testPos, 50%使用 cuePos，即有效性50%
    % trialTestPos = Shuffle(repmat([1, 2, 3, 4, 5], 1, nTrials / 10));
    % 2 / (3*6)
    % trialRewardPos = Shuffle(repmat([1, 2, 3, 4, 5, 6], 1, nTrials / 9));
    %
    
%% new end
    %无奖励
    nonRewardCondition = zeros(thirdTrials, nPos);
    %高奖励
    highRewardCondition = zeros(thirdTrials, nPos);
    %低奖励
    lowRewardCondition = zeros(thirdTrials, nPos);
    for i=1:thirdTrials
        nonRewardCondition(i,:) = randperm(nPos);
        highRewardCondition(i,:) = randperm(nPos);
        lowRewardCondition(i,:) = randperm(nPos);
    end
   
%% 读取图片
    % 指导语
    greetingTex = Screen('MakeTexture', window, ceil(imread('material\start.bmp')));
    errorTex = Screen('MakeTexture', window, ceil(imread('material\error.png', 'BackGround', backgroundColor/255)));
    correctTex = Screen('MakeTexture', window, ceil(imread('material\correct.png', 'BackGround', backgroundColor/255)));
    restTex = Screen('MakeTexture', window, ceil(imread('material\rest.png')));
    endTex = Screen('MakeTexture', window, ceil(imread('material\ending.png')));

    % 刺激材料
    imgNum = 10;
    mapTex = zeros(1, imgNum);
    for texIndex = 1:imgNum
        [im, imMap, imAlpha] = imread(['stimuli\m', num2str(texIndex), '.png']);
        im(:, :, 4) = imAlpha;
        mapTex(1, texIndex) = Screen('MakeTexture', window, im);  
    end

    [im, imMap, imAlpha] = imread('stimuli\arrow.png');
    im(:, :, 4) = imAlpha;
    barTex = Screen('MakeTexture', window, im);
    [im, imMap, imAlpha] = imread('stimuli\target.png');
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
    radius = 120; 
    %小圆的半径
    sectionRadius = 45; %45 小圆的半径 bar的一半
    % 检测项
    mapSize = 90;
    
    % 小圆圆心的坐标
    sections=cell([1 4]);
    sections{1} = [screenCenter(1), screenCenter(2) - radius];
    sections{2} = [screenCenter(1) + radius, screenCenter(2)];
    sections{3} = [screenCenter(1), screenCenter(2) + radius];
    sections{4} = [screenCenter(1) - radius, screenCenter(2)];
    
    %小圆轮廓坐标
    row1 = [sections{1}(1)-sectionRadius,sections{1}(2)-sectionRadius,sections{1}(1)+sectionRadius,sections{1}(2)+sectionRadius];
    row2 = [sections{2}(1)-sectionRadius,sections{2}(2)-sectionRadius,sections{2}(1)+sectionRadius,sections{2}(2)+sectionRadius];
    row3 = [sections{3}(1)-sectionRadius,sections{3}(2)-sectionRadius,sections{3}(1)+sectionRadius,sections{3}(2)+sectionRadius];
    row4 = [sections{4}(1)-sectionRadius,sections{4}(2)-sectionRadius,sections{4}(1)+sectionRadius,sections{4}(2)+sectionRadius];
    % 6 * 4， 使用时应该转置
    sectionRects = [row1; row2; row3; row4];
   
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
    stimuliDuration = 600 / 1000; 
    beforeCueDuration = 400 / 1000;
    cueDuration = 300 / 1000;
    beforeTestDuration = 500 / 1000;
    RTLimit = 2000 / 1000;
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
    for trialIndex = 1 : nTrials
        % 初始化参数
        % block tye
        block = find(blockPoints == trialIndex);
        if block > 0
            cueType = blockTypes(1, block);
        end
        currentColorSet=zeros(nPos,3);
        % tex order
        texOrder = randperm(imgNum);
        
        % 呈现注视点
        Screen('Flip', window);
        WaitSecs(trialInterval(trialIndex));
       
        Screen('FillRect', window, foreColor, fixRects');
        Screen('Flip', window);
        WaitSecs(fixDuration(trialIndex));
        
        if trialRewardLevel(trialIndex) == 0
            % Screen('DrawText', window, '无奖励')
			
            %呈现刺激
			for posIndex = 1 : nPos
				Screen('FillRect', window, nonRewardColorSet(posIndex, : ), sectionRects(posIndex, : ));
				Screen('DrawTexture', window, mapTex(texOrder(posIndex)), [], sectionRects(posIndex, : ));
			end
			Screen('Flip', window);
			WaitSecs(stimuliDuration);
            Screen('Flip', window);
            WaitSecs(beforeCueDuration);
			
			% cue
            if cueType == 1 
                arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];
                rotationAngle = 360 / nPos * trialCuePos(trialIndex);
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
%            if trialCueValidate(trialIndex) == 1
%                testPos = trialTestPos(trialIndex);
%                cue = '有效';
%            else
%                testPos = trialTestPos(trialIndex);
%                cue = '无效';
%            end
           testPos = trialTestPos(trialIndex);
           Screen('FillRect', window, testColor , [topLeft,bottomRight]);
           Screen('DrawTexture', window, mapTex(texOrder(testPos)), [], [topLeft,bottomRight]); 
           Screen('Flip', window);
           
		   nonRewardIndex = nonRewardIndex + 1;
        %elseif trialRewardPosition(trialIndex) < 7
        elseif trialRewardLevel(trialIndex) == 1
            % Screen('DrawText', window, '高奖励')
            %高奖励
            %呈现
            for posIndex=1 : nPos
                if posIndex == trialRewardPos(trialIndex)
                   currentColor = highRewardColor; % 颜色
                else
                    currentColor=nonRewardColorSet(highRewardCondition(highRewardIndex,posIndex), : ); 
                end

                % 颜色
                Screen('FillRect', window, currentColor, sectionRects(posIndex, : ));
                % 形状
                Screen('DrawTexture', window, mapTex(texOrder(posIndex)), [], sectionRects(posIndex, : )); 
                currentColorSet(posIndex,:)=currentColor;
            end
            Screen('Flip', window);
            WaitSecs(stimuliDuration);
            Screen('Flip', window);
            WaitSecs(beforeCueDuration);

           % cue 
            if cueType == 1 
                arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];
                rotationAngle = 360 / nPos * trialCuePos(trialIndex);
                Screen('DrawTexture', window, barTex, [], arrowCuePos, rotationAngle);
            else
                squareCuePos = sectionRects(trialCuePos(trialIndex), :);
                Screen('DrawTexture', window, targetTex, [], squareCuePos);
            end
            Screen('Flip', window);
            WaitSecs(cueDuration);
            Screen('Flip', window);
            WaitSecs(beforeTestDuration);
            
            % 检测
%             if trialCueValidate(trialIndex) == 1
%                testPos = trialCuePos(trialIndex);
%                cue = '有效';
%             else
%                testPos = trialTestPos(trialIndex);
%                cue = '无效';
%             end
            testPos = trialTestPos(trialIndex);
            Screen('FillRect', window, testColor , [topLeft,bottomRight]);
            Screen('DrawTexture', window, mapTex(texOrder(testPos)), [], [topLeft,bottomRight]); 
            Screen('Flip', window);

            highRewardIndex=highRewardIndex+1;
            rewardIndex = rewardIndex + 1;
        elseif trialRewardLevel(trialIndex) == 2
            % Screen('DrawText', window, '低奖励')
            % 呈现
            for posIndex=1 : nPos
                if posIndex==trialRewardPos(trialIndex)
                   currentColor=lowRewardColor; % 颜色
                else   
                   currentColor=nonRewardColorSet(lowRewardCondition(lowRewardIndex,posIndex),: ); 
                end
                % 颜色
                Screen('FillRect', window, currentColor, sectionRects(posIndex, : ));
                % 形状
                % map  只有六个形状，肯定是不行的
                Screen('DrawTexture', window, mapTex(texOrder(posIndex)), [], sectionRects(posIndex, : ));  
                currentColorSet(posIndex,:)=currentColor;
            end
            Screen('Flip', window);
            WaitSecs(stimuliDuration);
            Screen('Flip', window);
            WaitSecs(beforeCueDuration);

            % cue 
            if cueType == 1 
                arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];
                rotationAngle = 360 / nPos * trialCuePos(trialIndex);
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
%             if trialCueValidate(trialIndex) == 1
%                testPos = trialCuePos(trialIndex);
%                cue = '有效';
%             else
%                testPos = trialTestPos(trialIndex);
%                cue = '无效';
%             end
            testPos = trialTestPos(trialIndex);
            Screen('FillRect', window, testColor , [topLeft,bottomRight]);
            Screen('DrawTexture', window, mapTex(texOrder(testPos)), [], [topLeft,bottomRight]); 
            Screen('Flip', window);

            lowRewardIndex=lowRewardIndex+1;
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
                if (answer(trialIndex)== 1 && trialTestPos(trialIndex)<5 ) || (answer(trialIndex)== 2 && trialTestPos(trialIndex)>4 )
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
        if ismember(trialIndex, blockPoints(2:nBlocks)) %96
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
    trialTestPos(trialTestPos > nPos) = 0;
    currentTime = datestr(now);
    currentTime(currentTime == ':') = '-';
    
    save(strcat('results\Test\', subName));

    expData = num2cell([(1:nTrials)', trialRewardLevel', trialRewardPos', trialCueTypes', trialCuePos', trialTestPos', trialCueValidate', trialRewardValidate', RT', answer', answerCorrect']);
    result = [{'subName', 'subGender', 'KeySetting', 'RewardSetting', 'Trial',...
                                      'RewardLevel',  'RewardPosition', 'CueType', 'CuePosition', 'TestPosition',  'CueValid', 'RewardValid', 'RT', 'answer', 'answerCorrect'}; ...
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
    DrawFormattedText(window, [num2str(Sample([0.51, 0.52, 0.53, 0.54, 0.55]))], screenRect(3) / 2, screenRect(4) / 2 - 65 ); 
    
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