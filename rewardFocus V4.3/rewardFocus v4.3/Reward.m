function Reward(subName, subGender, oprMode, rewardSetting, keySetting)
    
Screen('Preference', 'SkipSyncTests', 1);

if nargin < 5
    subName = 'Test';
    subGender = '999';
    oprMode = 'test';
    rewardSetting = 1;   %1��2�ͱ��꣬3,4�߱���
    keySetting = 1; 
end

try
%% ������Ļ    
    backgroundColor = [150 150 150];
    foreColor = [0 0 0];
    
    [window, screenRect] = Screen('OpenWindow', 0, backgroundColor);
    physicalFrameRate = Screen('FrameRate', window);
    [screenCenter(1), screenCenter(2)] = RectCenter(screenRect);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    HideCursor;
    %����
    olds=Screen('TextSize',window,18);
    Screen('TextFont',window,'Microsoft Yahei');
   % Screen('TextColor',window,[227,23,13]);
   
%% ���尴����Ӧ
    KbName('UnifyKeyNames');
    if keySetting == 1
        keyF = KbName('LEFTARROW');%|
        keyJ = KbName('RIGHTARROW');%--
    else
        keyF = KbName('RIGHTARROW');% |
        keyJ = KbName('LEFTARROW');% --
    end
    keyESC = KbName('ESCAPE');
%% ��ȡ�̼�����
   
    %ָ����ͷ���
    greetingTex = Screen('MakeTexture', window, ceil(imread('material\start.bmp')));
    pauseTex = Screen('MakeTexture', window, ceil(imread('material\pause.bmp')));
    endTex = Screen('MakeTexture', window, ceil(imread('material\trainEnding.png')));
    errorTex = Screen('MakeTexture', window, ceil(imread('material\error.png', 'BackGround', backgroundColor/255)));
    correctTex = Screen('MakeTexture', window, ceil(imread('material\correct.png', 'BackGround', backgroundColor/255)));
    restTex = Screen('MakeTexture', window, ceil(imread('material\rest.png')));
    rightTex = Screen('MakeTexture', window, ceil(imread('material\right.png')));
    wrongTex = Screen('MakeTexture', window, ceil(imread('material\wrong.png')));
    
    %��ȡbar
    [im, imMap, imAlpha] = imread(['stimuli\bar.png']);
    im(:, :, 4) = imAlpha;
    barTex = Screen('MakeTexture', window, im);

    %��ɫ
    red = [255 0 0];
    green = [0 255 0];
    blue = [0 0 255];
    yellow = [255 255 0];
    cyan = [0 255 255];
    purple = [255 0 255];
    black = [0 0 0];
    pink = [255, 204, 204];
    
    %��ɫ��
    commonColorSet = [blue; yellow; cyan; black; purple; pink];
    rewardColorSet = [red; green];
    
    
%% ����ʵ�����

    %��Բ�İ뾶
    radius = 110; %220  СԲԲ�ĵ�ע�ӵ�
    
    %СԲ�İ뾶
    sectionRadius = 25; %45 СԲ�İ뾶 bar��һ��
    
    % СԲԲ�ĵ�����
    sections=cell([1 6]);
    sections{1} = [screenCenter(1)+radius*cos(11*pi/6),screenCenter(2)+radius*sin(11*pi/6)];
    sections{2 }=[screenCenter(1)+radius*cos(3*pi/2),screenCenter(2)+radius*sin(3*pi/2)];
    sections{3}=[screenCenter(1)+radius*cos(7*pi/6),screenCenter(2)+radius*sin(7*pi/6)];
    sections{4}=[screenCenter(1)+radius*cos(5*pi/6),screenCenter(2)+radius*sin(5*pi/6)];
    sections{5}= [screenCenter(1)+radius*cos(pi/2),screenCenter(2)+radius*sin(pi/2)];
    sections{6}= [screenCenter(1)+radius*cos(pi/6),screenCenter(2)+radius*sin(pi/6)];
    
    %СԲ��������
    sectionRects = cell([1 6]); 
    sectionRects{1} = [sections{1}(1)-sectionRadius,sections{1}(2)-sectionRadius,sections{1}(1)+sectionRadius,sections{1}(2)+sectionRadius];
    sectionRects{2} = [sections{2}(1)-sectionRadius,sections{2}(2)-sectionRadius,sections{2}(1)+sectionRadius,sections{2}(2)+sectionRadius];
    sectionRects{3} = [sections{3}(1)-sectionRadius,sections{3}(2)-sectionRadius,sections{3}(1)+sectionRadius,sections{3}(2)+sectionRadius];
    sectionRects{4} = [sections{4}(1)-sectionRadius,sections{4}(2)-sectionRadius,sections{4}(1)+sectionRadius,sections{4}(2)+sectionRadius];
    sectionRects{5} = [sections{5}(1)-sectionRadius,sections{5}(2)-sectionRadius,sections{5}(1)+sectionRadius,sections{5}(2)+sectionRadius]; 
    sectionRects{6} = [sections{6}(1)-sectionRadius,sections{6}(2)-sectionRadius,sections{6}(1)+sectionRadius,sections{6}(2)+sectionRadius];
    
    %����ע�ӵ������
    fixSize = [20 4]*2;
    fixRects = [CenterRect([0 0 fixSize], screenRect); ...
                CenterRect([0 0 fliplr(fixSize)], screenRect)];
    
    smallFixSize=  [10 2]*2;
    smallFixRects = [CenterRect([0 0 smallFixSize], screenRect); ...
                CenterRect([0 0 fliplr(smallFixSize)], screenRect)];
 
    nTrials = 240; 
    
    %�߽����͵ͽ����Ľ��
    highRewardLevel = Shuffle([0.5*ones(1,96), 0.01*ones(1,24)]);
    lowRewardLevel = Shuffle([0.01*ones(1,96), 0.5*ones(1,24)]);
    
    %����ģʽ
    if rewardSetting == 1
        highRewardCond = 1;%��
        lowRewardCond = 2;%��
    else
        highRewardCond = 2;%��
        lowRewardCond = 1;%��
    end
    
    %ʱ����
    trialInterval = rand([1 nTrials]) * 0.5 + 1;
    fixDuration = (400 + 200 * rand([1 nTrials])) / 1000;
    sectionPreviewDuration = 1000 / 1000;
    cueDuration = 100 / 1000;
    ISI = 200 / 1000;
    RTLimit = 3000 / 1000; 
    beforeFeedbackDuration = 1000 / 1000;
    feedDuration = 500 / 1000;
    feedbackDuration = 1500 / 1000;
    
%% ����ʵ������
    %������ɫ
    nonRewardColorCond=zeros(nTrials,6);
     for i=1:nTrials
        nonRewardColorCond(i,:)=randperm(6);
     end
     
    nConditions = 24; %ʵ��ˮƽ��
    trialCondition = ShiftMod(randperm(nTrials), nConditions);%����Ϊ240�ľ���(1-24)*10�������
        targetPosition = ceil(trialCondition / 4);%ת��Ϊ1~6 ��ʱ��
    
    trialCondition = ShiftMod(trialCondition, 4); %(1-4)*60
        colorType = ceil(trialCondition / 2);% 1~2 1_�죬2_��
         
    trialCondition = ShiftMod(trialCondition, 2);%(1~2)*120
        barType = trialCondition;%1~2 1_��ֱ 2_ˮƽ
        
%% ��¼����
    answer = zeros([1 nTrials]);
    answerCorrect = zeros([1 nTrials]);
    RT = zeros([1, nTrials]);
    
    currentRewardRow=zeros([1, nTrials]);
    totalRewardRow=zeros([1, nTrials]);
    totalReward = 0;
    highRewardIndex=0;
    lowRewardIndex=0;    
%% ��ʼʵ��
    isRunning = true;
    keyOperation = false;
    
   
    %׼��
     greetingTex = Screen('MakeTexture', window, ceil(imread('material\start.bmp')));
     
     
     Screen('DrawTexture', window, greetingTex);      
     keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
         [keyisdown,secs,keycode] = KbCheck;
         WaitSecs(0.001); % delay to prevent CPU hogging
    end
    Screen('Flip', window);
    KbWait;
          
     
    %����ʵ��
    for trialIndex = 1:nTrials
        
        Screen('Flip', window);
        WaitSecs(trialInterval(trialIndex));
        
        % ע�ӵ�
        Screen('FillRect', window, foreColor, smallFixRects');
        Screen('Flip', window);
        WaitSecs(fixDuration(trialIndex));
        
        % ����ԲȦ
        for positionIndex= 1:6
            
             if positionIndex==targetPosition(trialIndex)
                 currentColor= rewardColorSet(colorType(trialIndex),:);
                 currentAngle= 90*(barType(trialIndex)-1);
             else
                 currentColor=commonColorSet(nonRewardColorCond(trialIndex,positionIndex),:);
                 currentAngle=Sample([45,135]);
             end

             Screen('FrameOval',window, currentColor, sectionRects{positionIndex}, 4 );
             Screen('DrawTexture', window, barTex, [], sectionRects{positionIndex}, currentAngle);
        end
        %ע�ӵ�
       Screen('FillRect', window, foreColor, smallFixRects');
       Screen('Flip', window);
       
        %�ռ���Ӧ
        startTime = GetSecs;
        while GetSecs - startTime < RTLimit
            if GetSecs - startTime> sectionPreviewDuration
                Screen('Flip', window);
            end
            [keyDown, keyTime, keyState] = KbCheck();
            if keyDown
                if keyState(keyESC)
                    isRunning = false;
                    break;
                elseif keyState(keyF)
                    answer(trialIndex) = 1;%������ʾ|
                    RT(trialIndex) = round(1000*(keyTime - startTime));
                    break;
                elseif keyState(keyJ) 
                    answer(trialIndex) = 2;%������ʾ��
                    RT(trialIndex) = round(1000*(keyTime - startTime));
                    break;
                end            
            end
        end
        %�ȴ�����ֱ����Ӧ������
        Screen('Flip', window);
        
        if colorType(trialIndex)==1
            highRewardIndex=highRewardIndex+1;
        elseif colorType(trialIndex)==2
            lowRewardIndex=lowRewardIndex+1;
        end
        %����
        if ~isRunning
            break;
        else
            if answer(trialIndex) == barType(trialIndex)% answer(trialIndex) ==1��ʾ|��answer(trialIndex)==2��ʾ����barType(trialIndex)==1��ʾ|��==2��ʾ --
                answerCorrect(trialIndex) = 1;
                
                if highRewardCond == colorType(trialIndex)
                    %�߽���
                    currentReward = highRewardLevel(highRewardIndex);
                elseif lowRewardCond == colorType(trialIndex)
                    %�ͽ���
                    currentReward = lowRewardLevel(lowRewardIndex);
                end
                %��ȷ����
                totalReward = totalReward + currentReward;
				Screen('DrawTexture', window, rightTex);
                DrawFormattedText(window, num2str(currentReward), screenRect(3) / 2 + 30, screenRect(4) / 2 - 60 ); % [num2str(currentReward)]
                DrawFormattedText(window, num2str(totalReward), screenRect(3) / 2 - 70, screenRect(4) / 2 + 20 );   % [ num2str(totalReward)]                
            else %������
                answerCorrect(trialIndex) = 2;  
                currentReward = 0;
                totalReward = totalReward + currentReward;
                Screen('DrawTexture', window, wrongTex);
            end
            Screen('Flip', window);
            WaitSecs(feedbackDuration);
			Screen('TextColor',window,[0,0,0]); %����֮����ɫ�ָ�����
        end
        %��Ϣ
        if ismember(trialIndex,[80,160]) %80
           Screen('DrawTexture', window, restTex);
           %DrawFormattedText(window, ['����Ϣ�����ӣ������Ϣ�����밴���������ʵ��~'], 'center', screenRect(4) / 2 + 20 ); 
           Screen('Flip', window); 
           keyisdown = 1;
           while(keyisdown) % first wait until all keys are released
                     [keyisdown, secs, keycode] = KbCheck;
                     WaitSecs(0.001); % delay to prevent CPU hogging
          end
          KbWait;
                  
         
        end
        
          currentRewardRow(trialIndex)=currentReward;
          totalRewardRow(trialIndex)=totalReward;
    end
  
    
    % ��������
    currentTime = datestr(now);
    currentTime(currentTime == ':') = '-';

    save(strcat('results\train\', subName));

    expData = num2cell([(1:nTrials)', colorType', targetPosition', barType', RT', answer', answerCorrect',currentRewardRow',totalRewardRow']);
        %((trialCueValidate < 5) + 1)ʹ��1��ʾ��ʾ��Ч��2��ʾ��ʾ��Ч
    result = [{'subName', 'subGender', 'KeySetting', 'RewardSetting', 'Trial', 'colorType', 'targetPos', 'barType', 'RT', 'answer', 'answerCorrect','currentReward','totalReward'}; ...
         repmat({subName}, [nTrials 1]), repmat({subGender}, [nTrials 1]), repmat({keySetting}, [nTrials 1]), repmat({rewardSetting}, [nTrials 1]), expData];
 
    save(strcat('results\train\MAT_', subName), 'result');
    
    if strcmpi(oprMode, 'normal')
        xlswrite(strcat('results\train\Result_', currentTime, '_', subName, '.xls'), result);  
    else
        xlswrite(strcat('results\train\Result_', currentTime, '_', subName, '_Practice.xls'), result);
    end
   %����
    Screen('DrawTexture', window, endTex);
    DrawFormattedText(window, num2str(totalReward), screenRect(3) / 2 + 198, screenRect(4) / 2 - 50);  %[num2str(totalReward)]

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