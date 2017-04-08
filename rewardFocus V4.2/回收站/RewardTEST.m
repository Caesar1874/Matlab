function RewardTEST(subName, subGender, oprMode, rewardSetting, keySetting)

if nargin < 5
    subName = 'Test';
    subGender = '999';
    oprMode = 'test';
    rewardSetting = 1;
    keySetting = 1; 
end 

try 
%% ������Ļ    
    backgroundColor = [150 150 150];
    foreColor = [0 0 0];
    testColor = [255 255 255];
    Screen('Preference', 'SkipSyncTests', 1);
    [window, screenRect] = Screen('OpenWindow', 0, backgroundColor);
    physicalFrameRate = Screen('FrameRate', window);
    [screenCenter(1), screenCenter(2)] = RectCenter(screenRect);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    HideCursor;
    %����
    olds=Screen('TextSize',window,28);
    Screen('TextFont',window,'Microsoft Yahei');
    
%% ���尴����Ӧ
    KbName('UnifyKeyNames');
    if keySetting == 1
        keyF = KbName('LEFTARROW');% yes
        keyJ = KbName('RIGHTARROW');% no
    else
        keyF = KbName('RIGHTARROW');% yes
        keyJ = KbName('LEFTARROW');% no
    end
    keyESC = KbName('ESCAPE');
    
%% ��ȡ�̼�
    %6����״
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

    %8����ɫ
    red=[255 0 0];
    green=[0 255 0];
    blue=[0 0 255];
    yellow=[255 255 0];
    cyan=[0 255 255];
    purple=[255 0 255];
    black=[0 0 0];
    pink = [255, 204, 204];
    
    nonRewardColorSet=[blue; yellow; cyan; black; pink; purple]; 
    
    %����������ɫ
    if rewardSetting==1
        highRewardColor=red;
        lowRewardColor=green;
    elseif rewardSetting==2
        highRewardColor=green;
        lowRewardColor=red;
    end
    
    % ��ȡͼ�β���
    greetingTex = Screen('MakeTexture', window, ceil(imread('material\start.bmp')));
    pauseTex = Screen('MakeTexture', window, ceil(imread('material\pause.bmp')));
    endTex = Screen('MakeTexture', window, ceil(imread('material\end.bmp')));
    errorTex = Screen('MakeTexture', window, ceil(imread('material\error.png', 'BackGround', backgroundColor/255)));
    correctTex = Screen('MakeTexture', window, ceil(imread('material\correct.png', 'BackGround', backgroundColor/255)));
    restTex = Screen('MakeTexture', window, ceil(imread('material\rest.png')));
    endTex = Screen('MakeTexture', window, ceil(imread('material\ending.png')));
    rewardTex = Screen('MakeTexture', window, ceil(imread('material\reward.png')));
    
    
%% ����ʵ�����

%��Բ�İ뾶
    radius = 110; %220  СԲԲ�ĵ�ע�ӵ�
    
    %СԲ�İ뾶
    sectionRadius = 45; %45 СԲ�İ뾶 bar��һ��
    
    % СԲԲ�ĵ�����
    sections=cell([1 6]);
    sections{1} = [screenCenter(1)+radius*cos(11*pi/6),screenCenter(2)+radius*sin(11*pi/6)];
    sections{2 }=[screenCenter(1)+radius*cos(3*pi/2),screenCenter(2)+radius*sin(3*pi/2)];
    sections{3}=[screenCenter(1)+radius*cos(7*pi/6),screenCenter(2)+radius*sin(7*pi/6)];
    sections{4}=[screenCenter(1)+radius*cos(5*pi/6),screenCenter(2)+radius*sin(5*pi/6)];
    sections{5}= [screenCenter(1)+radius*cos(pi/2),screenCenter(2)+radius*sin(pi/2)];
    sections{6}= [screenCenter(1)+radius*cos(pi/6),screenCenter(2)+radius*sin(pi/6)];
    
    %СԲ��������
    % sectionRects = cell([1 6]); 
    row1 = [sections{1}(1)-sectionRadius,sections{1}(2)-sectionRadius,sections{1}(1)+sectionRadius,sections{1}(2)+sectionRadius];
    row2 = [sections{2}(1)-sectionRadius,sections{2}(2)-sectionRadius,sections{2}(1)+sectionRadius,sections{2}(2)+sectionRadius];
    row3 = [sections{3}(1)-sectionRadius,sections{3}(2)-sectionRadius,sections{3}(1)+sectionRadius,sections{3}(2)+sectionRadius];
    row4 = [sections{4}(1)-sectionRadius,sections{4}(2)-sectionRadius,sections{4}(1)+sectionRadius,sections{4}(2)+sectionRadius];
    row5 = [sections{5}(1)-sectionRadius,sections{5}(2)-sectionRadius,sections{5}(1)+sectionRadius,sections{5}(2)+sectionRadius]; 
    row6 = [sections{6}(1)-sectionRadius,sections{6}(2)-sectionRadius,sections{6}(1)+sectionRadius,sections{6}(2)+sectionRadius];
    % 6 * 4�� ʹ��ʱӦ��ת��
    sectionRects = [row1; row2; row3; row4; row5; row6];
   
    % �����
    mapSize = 150; 
    topLeft=[screenCenter(1)-mapSize/2, screenCenter(2)-mapSize/2];
    topRight=[screenCenter(1)+mapSize/2, screenCenter(2)-mapSize/2];
    bottomRight=[screenCenter(1)+mapSize/2, screenCenter(2)+mapSize/2];
    bottomLeft=[screenCenter(1)-mapSize/2, screenCenter(2)+mapSize/2];
    
    %ע�ӵ�
    fixSize = [15 2]*2;
    fixRects = [CenterRect([0 0 fixSize], screenRect); ...
                CenterRect([0 0 fliplr(fixSize)], screenRect)];
    
    %trial��
    nTrials = 1296;
    triNTrials=nTrials/3;
 
    
    %ʱ��
    trialInterval = rand([1 nTrials]) * 0.5 + 1;
    fixDuration = (400 + 200 * rand([1 nTrials])) / 1000;
    sectionPreviewDuration = 100 / 1000; %100ms
%     cueDuration = 100 / 1000;
    ISI = 1000 / 1000; % 400ms����
    RTLimit = 3000 / 1000;
    beforeTestkDuration = 1000 / 1000;
    feedDuration = 500 / 1000;
%     feedbackDuration = 1500 / 1000;
    
%% ����ʵ������
    %������
    nConditions = 1296;  
    
    %�޽���
    nonRewardCondition = zeros(triNTrials,6);
    %�߽���
    highRewardCondition = zeros(triNTrials,6);
    %�ͽ���
    lowRewardCondition = zeros(triNTrials,6);
    for i=1:triNTrials
        nonRewardCondition(i,:) = randperm(6);
        highRewardCondition(i,:) = randperm(6);
        lowRewardCondition(i,:) = randperm(6);
    end
    
    %�������
     trialCondition = ShiftMod(randperm(nTrials), nConditions);%(1 ~ 1296)  
        trialTestPosition=ceil(trialCondition / 108); % 1-12
        % 1 ~ 6 ��ʾ�ظ���7��ʾ����̼�����ռһ��
        trialTestPosition( trialTestPosition > 6 ) = 7;
     
     trialCondition = ShiftMod(trialCondition, 108); % 1 ~ 108
        trialRewardPosition=ceil(trialCondition / 12); % 1 ~ 9
        % 1 ~ 6 ��ʾ 6 ��rewardPos, 7 ��ʾ �޽�����ռ 1 / 3
        trialRewardPosition(trialRewardPosition > 6) = 7;
     
    trialCondition = ShiftMod(trialCondition, 12) % 1 ~ 12
    trialCuePosition = ceil(trialCondition / 2); % 1 - 6
     
     trialCondition = ShiftMod(trialCondition, 2);% 1 - 2
        trialRewardLevel=trialCondition;
        trialRewardLevel(trialRewardPosition > 6) = 0;
    
        
%% ����
    answer = zeros([1 nTrials]);
    answerCorrect = zeros([1 nTrials]);
    RT = zeros([1, nTrials]);
    
    %����������
    nonRewardIndex = 1;
    highRewardIndex = 1;
    lowRewardIndex = 1;
    rewardIndex = 1;
  
%% ��ʼʵ��
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
    isRunning = true;
    keyOperation = false;
    
%����ʵ��   
    for trialIndex = 1:nTrials
        %��ʼ������
        % block type�� 4 �� block
        nBlock = find([1, 325, 645, 972] == trialIndex);
        if nBlock > 0
            blockTypes = [1, 1, 2, 2];
            blockOrder = randperm(4);
            cueType = blockTypes(1, blockOrder(nBlock));
        end
        
        currentColorSet=zeros(6,3);
        texOrder = randperm(imgNum);
        
        Screen('Flip', window);
        WaitSecs(trialInterval(trialIndex));
        % ����ע�ӵ�
        Screen('FillRect', window, foreColor, fixRects');
        Screen('Flip', window);
        WaitSecs(fixDuration(trialIndex));
        
        if trialRewardLevel(trialIndex) == 0
            Screen('DrawText', window, '�޽���')
			%���ִ̼�
			% ͬʱ����������ɫ + ����͸����״
			for positionIndex = 1 : 6
				% ��ɫ
				Screen('FillRect', window, nonRewardColorSet(positionIndex, : ), sectionRects(positionIndex, : ));
				% ��״
				% map  ֻ��������״���϶��ǲ��е�
				Screen('DrawTexture', window, mapTex(1, texOrder(positionIndex)), [], sectionRects(positionIndex, : ));
			end
			Screen('Flip', window);
			WaitSecs(ISI);
			
			% cue 
            if cueType == 1 
                arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];
            
            rotationAngle = 60 * trialCuePosition(trialIndex)
                Screen('DrawTexture', window, barTex, [], arrowCuePos, rotationAngle);
            else
                squareCuePos = sectionRects(trialCuePosition(trialIndex), :);
                Screen('DrawTexture', window, targetTex, [], squareCuePos);
                % Screen('FrameRect', window, [255, 255, 255], squareCuePos, 3);
            end
			Screen('Flip', window);
			WaitSecs(2);

		   %���
           Screen('FillRect', window, foreColor, fixRects');
           Screen('Flip', window);
           WaitSecs( beforeTestkDuration);	
           Screen('FillRect', window, testColor , [topLeft,bottomRight]);
           Screen('DrawTexture', window, mapTex(texOrder( trialTestPosition(trialIndex))), [], [topLeft,bottomRight]); 
           Screen('Flip', window);
           
		   nonRewardIndex = nonRewardIndex + 1;
        elseif trialRewardPosition(trialIndex) < 7
            if trialRewardLevel(trialIndex) == 1
                Screen('DrawText', window, '�߽���')
                %�߽���
				%����
				for positionIndex=1:6
					if positionIndex == trialRewardPosition(trialIndex)
					   currentColor = highRewardColor; % ��ɫ
					else
						currentColor=nonRewardColorSet(highRewardCondition(highRewardIndex,positionIndex), : ); 
					end
					
					% ��ɫ
					Screen('FillRect', window, currentColor, sectionRects(positionIndex, : ));
					% ��״
					Screen('DrawTexture', window, mapTex(texOrder(positionIndex)), [], sectionRects(positionIndex, : )); 
					currentColorSet(positionIndex,:)=currentColor;
				end
				Screen('Flip', window);
				WaitSecs(ISI);

               % cue 
                if cueType == 1 
                    arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];

                rotationAngle = 60 * trialCuePosition(trialIndex)
                    Screen('DrawTexture', window, barTex, [], arrowCuePos, rotationAngle);
                else
                    squareCuePos = sectionRects(trialCuePosition(trialIndex), :);
                    Screen('DrawTexture', window, targetTex, [], squareCuePos);
                % Screen('FrameRect', window, [255, 255, 255], squareCuePos, 3);
                end
                Screen('Flip', window);
                WaitSecs(2);

                
				%���
				Screen('FillRect', window, foreColor, fixRects');
				Screen('Flip', window);
				WaitSecs( beforeTestkDuration);	
				Screen('FillRect', window, testColor , [topLeft,bottomRight]);
				Screen('DrawTexture', window, mapTex(texOrder( trialTestPosition(trialIndex))), [], [topLeft,bottomRight]); 
				Screen('Flip', window);
				
				highRewardIndex=highRewardIndex+1;
            elseif trialRewardLevel(trialIndex) == 2
                Screen('DrawText', window, '�ͽ���')
				%����
				for positionIndex=1:6
					if positionIndex==trialRewardPosition(trialIndex)
					   currentColor=lowRewardColor; % ��ɫ
                    else   
					   currentColor=nonRewardColorSet(lowRewardCondition(lowRewardIndex,positionIndex),: ); 
					end
					% ��ɫ
					Screen('FillRect', window, currentColor, sectionRects(positionIndex, : ));
					% ��״
					% map  ֻ��������״���϶��ǲ��е�
					Screen('DrawTexture', window, mapTex(texOrder(positionIndex)), [], sectionRects(positionIndex, : ));  
					currentColorSet(positionIndex,:)=currentColor;
					
				end
				Screen('Flip', window);
				WaitSecs(ISI);
                
				% cue 
                if cueType == 1 
                    arrowCuePos = [screenCenter(1) - 50, screenCenter(2) - 50, screenCenter(1) + 50, screenCenter(2) + 50];

                rotationAngle = 60 * trialCuePosition(trialIndex)
                    Screen('DrawTexture', window, barTex, [], arrowCuePos, rotationAngle);
                else
                    squareCuePos = sectionRects(trialCuePosition(trialIndex), :);
                    Screen('DrawTexture', window, targetTex, [], squareCuePos);
                % Screen('FrameRect', window, [255, 255, 255], squareCuePos, 3);
                end
                Screen('Flip', window);
                WaitSecs(2);


				%���
				Screen('FillRect', window, foreColor, fixRects');
				Screen('Flip', window);
				WaitSecs( beforeTestkDuration);	
				Screen('FillRect', window, testColor , [topLeft,bottomRight]);
				Screen('DrawTexture', window, mapTex(texOrder( trialTestPosition(trialIndex))), [], [topLeft,bottomRight]); 
				Screen('Flip', window);
				
				lowRewardIndex=lowRewardIndex+1;
            end
            rewardIndex=rewardIndex + 1;
        end

        %�ռ���Ӧ
        startTime = GetSecs;
        while GetSecs - startTime < RTLimit
            [keyDown, keyTime, keyState] = KbCheck();
            if keyDown
                if keyState(keyESC)
                    isRunning = false;
                    break;
                elseif keyState(keyF)
                    answer(trialIndex) = 1;%������ʾyes
                    RT(trialIndex) = round(1000*(keyTime - startTime));
                    break;
                elseif keyState(keyJ)
                    answer(trialIndex) = 2;%������ʾno
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
          
            % ��ϰ ����
            Screen('Flip', window);
            WaitSecs(feedDuration);
        end
        

        
        %��Ϣ
        if ismember(trialIndex,[96, 192, 288, 384, 480, 576, 672, 768, 864, 960, 1056]) %96
            Screen('TextColor',window,[0,0,0]);
            Screen('DrawTexture', window, restTex);
%            DrawFormattedText(window, ['����Ϣ�����ӣ������Ϣ�����밴���������ʵ��~'], 'center', screenRect(4) / 2 + 20 ); 
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
    
    
    % ��������
    currentTime = datestr(now);
    currentTime(currentTime == ':') = '-';

%         trialRewardLevel=trialRewardPosition;
%             trialRewardLevel(trialRewardPosition>4)=0; %�޽���
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
    %����
%     Screen('TextColor',window,[0,0,0]);
    Screen('DrawTexture', window, endTex);
    DrawFormattedText(window, [num2str(Sample([0.73, 0.75, 0.74, 0.76, 0.77]))], screenRect(3) / 2, screenRect(4) / 2 - 65 ); 
    
%     DrawFormattedText(window, ['�벻Ҫ�����κβ�������ϵ���ԣ�лл����'], 'center', screenRect(4) / 2 + 30 ); 
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