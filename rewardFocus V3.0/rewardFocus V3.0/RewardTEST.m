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
    [center(1),center(2)] = RectCenter(screenRect);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    HideCursor;
    %字体
    olds=Screen('TextSize',window,28);
    Screen('TextFont',window,'Microsoft Yahei');
    
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
    
%% 读取刺激
    %6种形状
    mapTex = zeros([1 6]);
    for texIndex = 1:6
        [im, imMap, imAlpha] = imread(['stimuli\m', num2str(texIndex), '.png']);
        im(:, :, 4) = imAlpha;
        mapTex(texIndex) = Screen('MakeTexture', window, im);        
    end
    mapCombination={
        mapTex(1), mapTex(2), mapTex(3), mapTex(4), mapTex(5), mapTex(6);
    };

    %8种颜色
    red=[255 0 0];
    green=[0 255 0];
    blue=[0 0 255];
    yellow=[255 255 0];
    cyan=[0 255 255];
    purple=[255 0 255];
    black=[0 0 0];
    pink = [255, 204, 204];
    
    nonRewardColorSet=[blue; yellow; cyan; black; pink; purple]; 
    
    %奖励联结颜色
    if rewardSetting==1
        highRewardColor=red;
        lowRewardColor=green;
    elseif rewardSetting==2
        highRewardColor=green;
        lowRewardColor=red;
    end
    
    % 读取图形材料
    greetingTex = Screen('MakeTexture', window, ceil(imread('material\start.bmp')));
    pauseTex = Screen('MakeTexture', window, ceil(imread('material\pause.bmp')));
    endTex = Screen('MakeTexture', window, ceil(imread('material\end.bmp')));
    errorTex = Screen('MakeTexture', window, ceil(imread('material\error.png', 'BackGround', backgroundColor/255)));
    correctTex = Screen('MakeTexture', window, ceil(imread('material\correct.png', 'BackGround', backgroundColor/255)));
    restTex = Screen('MakeTexture', window, ceil(imread('material\rest.png')));
    endTex = Screen('MakeTexture', window, ceil(imread('material\ending.png')));
    rewardTex = Screen('MakeTexture', window, ceil(imread('material\reward.png')));
    
    
%% 定义实验参数
    %图形大小
    mapSize = 150; %未参照普
    colorSize = 100; %测试
    %注视点
    fixSize = [15 2]*2;
    fixRects = [CenterRect([0 0 fixSize], screenRect); ...
                CenterRect([0 0 fliplr(fixSize)], screenRect)];
            
    %坐标
    topLeft=[center(1)-mapSize/2, center(2)-mapSize/2];
    topRight=[center(1)+mapSize/2, center(2)-mapSize/2];
    bottomRight=[center(1)+mapSize/2, center(2)+mapSize/2];
    bottomLeft=[center(1)-mapSize/2, center(2)+mapSize/2];
    
    colorSquare = [
        [center(1) - colorSize / 2, center(2) - colorSize / 2];
        [center(1) + colorSize / 2, center(2) - colorSize / 2];
        [center(1) + colorSize / 2, center(2) + colorSize / 2];
        [center(1) - colorSize / 2, center(2) + colorSize / 2]
    
    ];
    
    
%     top=[center(1), center(2)-mapSize/2];
%     right=[center(1)+mapSize/2, center(2)];
%     bottom=[ center(1), center(2)+mapSize/2];
%     left=[center(1)-mapSize/2, center(2)];
% 
%     bottomQuaterLeft=[center(1)-mapSize/4, center(2)+mapSize/2];
%     bottomQuaterRight=[ center(1)+mapSize/4, center(2)+mapSize/2];
    
    %6种图形
    square=[topLeft; topRight; bottomRight; bottomLeft];
%     triangle=[top; bottomRight; bottomLeft];
%     diamond=[top; right; bottom; left];
%     circle=[topLeft, bottomRight];%不能区分sexangle
%     sexangle=[topLeft, bottomRight];
%     trapezoid=[right; bottomQuaterRight; bottomQuaterLeft; left];
     
    
    %trial数
    nTrials = 1152; % 576
    triNTrials=nTrials/3;
 
    
    %时间
    trialInterval = rand([1 nTrials]) * 0.5 + 1;
    fixDuration = (400 + 200 * rand([1 nTrials])) / 1000;
    sectionPreviewDuration = 100 / 1000; %100ms
%     cueDuration = 100 / 1000;
    ISI = 400 / 1000; %400ms空屏
    RTLimit = 3000 / 1000;
    beforeTestkDuration = 1000 / 1000;
    feedDuration = 500 / 1000;
%     feedbackDuration = 1500 / 1000;
    
%% 生成实验条件
    %条件数
    nConditions = 96;  
    
    %无奖励
    nonRewardCondition=zeros(triNTrials,6);
    %高奖励
    highRewardCondition=zeros(triNTrials,4);
    %低奖励
    lowRewardCondition=zeros(triNTrials,4);
    for i=1:triNTrials
        nonRewardCondition(i,:)=randperm(6);
        highRewardCondition(i,:)=randperm(4);
        lowRewardCondition(i,:)=randperm(4);
    end
    
    %随机条件
     trialCondition = ShiftMod(randperm(nTrials), nConditions);%(1~96)
        trialTestPosition=ceil(trialCondition / 12);%1-8
        trialTestPosition( trialTestPosition>4 )=5;
     
     trialCondition = ShiftMod(trialCondition, 12); %(1~12)
        trialRewardPosition=ceil(trialCondition / 2);%(1~6) 
        	
     trialCondition = ShiftMod(trialCondition, 2);%1-2
        trialRewardLevel=trialCondition;
        trialRewardLevel(trialRewardPosition>4)=0;
    %trialCondition = ShiftMod(randperm(nTrials), 5); %(1~5)   
        
%% 变量
    answer = zeros([1 nTrials]);
    answerCorrect = zeros([1 nTrials]);
    RT = zeros([1, nTrials]);
    
    %各条件计数
    nonRewardIndex=1;
    highRewardIndex=1;
    lowRewardIndex=1;
    rewardIndex=1;
    %trialRewardLevel=zeros(1,nTrials);
    %trialCurrentColorIndex=zeros(nTrials, 4);
%% 开始实验
%准备
     greetingTex = Screen('MakeTexture', window, ceil(imread('material\start.bmp')));
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
    
%进入实验   
    for trialIndex = 1:nTrials
        
        %初始化参数
        currentColorSet=zeros(6,3);
        
        randSeeds = randperm(6);
        
        Screen('Flip', window);
        WaitSecs(trialInterval(trialIndex));
        
        % 呈现注视点
        Screen('FillRect', window, foreColor, fixRects');
        Screen('Flip', window);
        WaitSecs(fixDuration(trialIndex));
        
       
%无奖励    
    if trialRewardLevel(trialIndex) == 0
        %呈现
        for positionIndex=1:4
            % 颜色类型
            Screen('FillPoly', window, nonRewardColorSet(nonRewardCondition(nonRewardIndex,positionIndex),:), colorSquare);
            % 形状
            Screen('DrawTexture', window, mapCombination{randSeeds(positionIndex)}, [], [topLeft,bottomRight]); %topLeft-100,bottomRight+100
            Screen('Flip', window);
            WaitSecs(sectionPreviewDuration);
            Screen('Flip', window);
            
            WaitSecs(ISI);
            %记录颜色索引
            %trialCurrentColorIndex(trialIndex,positionIndex)=nonRewardCondition(nonRewardIndex,positionIndex);
        end
       %检测
        Screen('FillRect', window, foreColor, fixRects');
        Screen('Flip', window);
        WaitSecs( beforeTestkDuration);
        
        % 去掉颜色换成形状
%         trialTestColor = nonRewardColorSet(nonRewardCondition(nonRewardIndex,trialTestPosition(trialIndex) ),:);
%         Screen('FillPoly', window, trialTestColor, square);
        
          Screen('FillPoly', window, testColor , colorSquare);
          Screen('DrawTexture', window, mapCombination{ randSeeds( trialTestPosition(trialIndex)) }, [], [topLeft,bottomRight]); %topLeft,bottomRight
        
%         DrawFormattedText(window, ['无奖励'], 'center', screenRect(4) / 2 + 20 ); %测试
        Screen('Flip', window);
       
       nonRewardIndex=nonRewardIndex+1;
%        trialRewardLevel(trialIndex)=0;
	
    elseif trialRewardPosition(trialIndex)<5
%高奖励
    if trialRewardLevel(trialIndex)==1
        %呈现
        for positionIndex=1:4
            if positionIndex==trialRewardPosition(trialIndex)
               currentColor=highRewardColor;%颜色
            else
                currentColor=nonRewardColorSet(highRewardCondition(highRewardIndex,positionIndex),: ); 
            end
            
            Screen('FillPoly', window, currentColor , colorSquare);
            Screen('DrawTexture', window, mapCombination{randSeeds(positionIndex)}, [], [topLeft,bottomRight]); %topLeft,bottomRight
            currentColorSet(positionIndex,:)=currentColor;
               
            Screen('Flip', window);
            WaitSecs(sectionPreviewDuration);
            Screen('Flip', window);
            WaitSecs(ISI);
            
            %trialCurrentColorIndex(trialIndex,positionIndex)=nonRewardCondition(nonRewardIndex,positionIndex);
        end
        
%         currentColorSet(5,:)=white;
%         currentColorSet(6,:)=pink;%nonRewardColorSet(6,:);
        
        %检测
        Screen('FillRect', window, foreColor, fixRects');
        Screen('Flip', window);
        WaitSecs( beforeTestkDuration);

%         trialTestColor=currentColorSet(nonRewardCondition(highRewardIndex,trialTestPosition(trialIndex)),: );
        Screen('FillPoly', window, testColor , colorSquare);
        Screen('DrawTexture', window, mapCombination{ randSeeds( trialTestPosition(trialIndex)) }, [], [topLeft,bottomRight]); %topLeft,bottomRight

        Screen('Flip', window);
        
        highRewardIndex=highRewardIndex+1;
%         trialRewardLevel(trialIndex)=1;
    end
%低奖励
    if trialRewardLevel(trialIndex)==2
        %呈现
        for positionIndex=1:4
            if positionIndex==trialRewardPosition(trialIndex)
               currentColor=lowRewardColor; % 颜色
            else
               currentColor=nonRewardColorSet(lowRewardCondition(lowRewardIndex,positionIndex),: ); 
            end
            
            Screen('FillPoly', window, currentColor , colorSquare);
            Screen('DrawTexture', window, mapCombination{randSeeds(positionIndex)}, [], [topLeft,bottomRight]); %topLeft,bottomRight
            currentColorSet(positionIndex,:)=currentColor;
        
            Screen('Flip', window);
            WaitSecs(sectionPreviewDuration);
            Screen('Flip', window);
            WaitSecs(ISI);
        end
        
%         currentColorSet(5,:)=white;%nonRewardColorSet(5,:);
%         currentColorSet(6,:)=pink;%nonRewardColorSet(6,:);
        %检测
        Screen('FillRect', window, foreColor, fixRects');
        Screen('Flip', window);
        WaitSecs( beforeTestkDuration);
       
        
%         trialTestColor= currentColorSet(nonRewardCondition(lowRewardIndex,trialTestPosition(trialIndex)),: );
        Screen('FillPoly', window, testColor, colorSquare);
        Screen('DrawTexture', window, mapCombination{ randSeeds( trialTestPosition(trialIndex)) }, [], [topLeft,bottomRight]); %topLeft,bottomRight
%         DrawFormattedText(window, ['低奖励'], 'center', screenRect(4) / 2 + 20 ); %测试
        Screen('Flip', window);
        
        lowRewardIndex=lowRewardIndex+1;
%         trialRewardLevel(trialIndex)=2;
    end
        rewardIndex=rewardIndex+1;
    end

        
        %收集反应
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

%         trialRewardLevel=trialRewardPosition;
%             trialRewardLevel(trialRewardPosition>4)=0; %无奖励
%              trialRewardLevel(rewardHighorLow==1)=1;
%              trialRewardLevel(rewardHighorLow==2)=2;

    
    save(strcat('results\Test\', subName));

    expData = num2cell([(1:nTrials)', trialRewardLevel', trialRewardPosition', trialTestPosition', RT', answer', answerCorrect']);
    result = [{'subName', 'subGender', 'KeySetting', 'RewardSetting', 'Trial',...
                                      'RewardLevel',    'RewardPosition',  'TestPosition'   ,'RT', 'answer', 'answerCorrect'}; ...
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