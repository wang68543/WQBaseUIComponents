//
//  WQKeyboardManager.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/2/28.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQKeyboardAdjustHelp.h"
@interface WQKeyboardAdjustHelp()<UITextViewDelegate,UITextFieldDelegate>
//@property (assign ,nonatomic) BOOL keyboardChangeing;
@property (strong ,nonatomic) UITapGestureRecognizer *tapGR;

@end
@implementation WQKeyboardAdjustHelp{
    NSInteger _excludeTag;
    NSArray <WQTextFiledView *> *_textFieldViews;//从上到下依次排列
    WQTextFiledView* _firstTextFieldView;//第一响应者
//    BOOL hasConfigDelegates;
    UIView *_lastView;
    UIView *_adjustView;
    UIScrollView *_adjustScrollView;
    CGPoint _preContentOffset;//记录scollView初始的offset
    CGAffineTransform _preTransform;
    
    UIView *_gestureView;
    
}
+(instancetype)keyboardAdjustHelpWithView:(UIView *)view excludeTag:(NSInteger)excludeTag{
    return [self keyboardAdjustWithMoveView:view gestureRecognizerView:view excludeTag:excludeTag];
}
+(instancetype)keyboardAdjustWithMoveView:(UIView *)moveView gestureRecognizerView:(UIView *)gestureView excludeTag:(NSInteger)excludeTag{
    return [[self alloc] initWithMoveView:moveView gestureRecognizerView:gestureView excludeTag:excludeTag];
}
-(instancetype)initWithMoveView:(UIView *)moveView gestureRecognizerView:(UIView *)gestureView excludeTag:(NSInteger)excludeTag{
    if(self = [super init]){
        _lastView = moveView;
        if([moveView isKindOfClass:[UIScrollView class]]){
            _adjustScrollView = (UIScrollView *)moveView;
            _preContentOffset = _adjustScrollView.contentOffset;
        }else{
            _adjustView = moveView;
            _preContentOffset = CGPointZero;
        }
        _preTransform = moveView.transform;
        _excludeTag = excludeTag;
        _animationCurve = UIViewAnimationCurveEaseInOut;
        _animationDuration = 0.25;
        _keyboardDistanceFromTextField = 10.0;
        
        if(moveView){
           [self rigisterNotification];
            //放在这里是为了让键盘的returnKey初始化
            [self findAllTextFileds];
            [self setDelegates];
        }
        _gestureView = gestureView;
        if(gestureView){
            _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
           [gestureView addGestureRecognizer:_tapGR];
        }
    }
    return self;
}

-(void)tapBackground:(UITapGestureRecognizer *)tapGR{
//    self.keyboardChangeing = NO;
    if(_gestureView){
        [_gestureView endEditing:YES];
    }else{
      [_lastView endEditing:YES];  
    }
    
}
//MARK: -- 给所有的输入框设置代理
-(void)setDelegates{
    __weak typeof(self) weakSelf = self;
    [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.tag < _excludeTag || _excludeTag != NSNotFound){
           [obj setValue:weakSelf forKey:@"delegate"];
        }
        if(obj.keyboardType != UIKeyboardTypeNumberPad || obj.keyboardType != UIKeyboardTypePhonePad || obj.keyboardType != UIKeyboardTypeDecimalPad){
            if(idx != _textFieldViews.count - 1){
                obj.returnKeyType = UIReturnKeyNext;
            }else{
                obj.returnKeyType = UIReturnKeyDone;
            }
        }
    }];
}

//MARK: -- 输入框代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self changeFirstResponder:textField];
    return NO;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [self changeFirstResponder:textView];
        return NO;
    }else{
        return YES;
    }
}

-(void)changeFirstResponder:(WQTextFiledView *)textFiledView{
    
    //  [_inputView reloadInputViews];  从别的inputView切换为系统键盘
    
    NSInteger index = [_textFieldViews indexOfObject:textFiledView];
    if(index < _textFieldViews.count -1 && index >= 0){
        WQTextFiledView* inputView = _textFieldViews[index + 1];
        if(_excludeTag != NSNotFound){
            if(inputView.tag < _excludeTag){
//                self.keyboardChangeing = YES;
//                if((textFiledView.keyboardType != inputView.keyboardType)|| textFiledView.inputView != inputView.inputView){
//                    self.keyboardChangeing = YES;
//                    [textFiledView resignFirstResponder];
//                }
                [inputView becomeFirstResponder];
            }else{
//                self.keyboardChangeing = NO;
//                [textFiledView resignFirstResponder];
            }
        }else{
//            self.keyboardChangeing = YES;
//            [textFiledView resignFirstResponder];
//            if((textFiledView.keyboardType != inputView.keyboardType)|| textFiledView.inputView != inputView.inputView){
//                self.keyboardChangeing = YES;
//                [textFiledView resignFirstResponder];
//            }
            [inputView becomeFirstResponder];
        }
    }else{
//        self.keyboardChangeing = NO;
       [textFiledView resignFirstResponder];
        
    }
    
    
    TextType textType = TextTypeView;
    if([textFiledView isKindOfClass:[UITextField class]]){
        textType = TextTypeFiled;
    }
    if([self.delegate respondsToSelector:@selector(keyboardAdjustShouldNext:textType:content:)]){
        [self.delegate keyboardAdjustShouldNext:textFiledView textType:textType content:[textFiledView valueForKey:@"text"]];
    }
    if([self.delegate respondsToSelector:@selector(keyboardAdjustShouldDone:textType:content:)]){
        [self.delegate keyboardAdjustShouldDone:textFiledView textType:textType content:[textFiledView valueForKey:@"text"]];
    }
}
//MARK: -- 注册键盘相关的通知
-(void)rigisterNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - UIKeyboad Notification methods

//MARK: --找出所有的输入框 并排序
-(void)findAllTextFileds{
    if(_textFieldViews) return;
    NSArray *tfViews = [self deepInputTextViews:_lastView];
    if(tfViews.count > 0){
        _textFieldViews =  [tfViews sortedArrayUsingComparator:^NSComparisonResult(UIView *  _Nonnull view1, UIView *  _Nonnull view2) {
            CGRect frame1 = [view1 convertRect:view1.bounds toView:_lastView];
            CGRect frame2 = [view2 convertRect:view2.bounds toView:_lastView];
            CGFloat x1 = CGRectGetMinX(frame1);
            CGFloat y1 = CGRectGetMinY(frame1);
            CGFloat x2 = CGRectGetMinX(frame2);
            CGFloat y2 = CGRectGetMinY(frame2);
            
            if (y1 < y2)  return NSOrderedAscending;
            
            else if (y1 > y2) return NSOrderedDescending;
            
            //Else both y are same so checking for x positions
            else if (x1 < x2)  return NSOrderedAscending;
            
            else if (x1 > x2) return NSOrderedDescending;
            
            else    return NSOrderedSame;
        }];
    }else{
        _textFieldViews = tfViews;
    }
   
}

//MARK: -- 查找一个View中所有的输入框
-(NSArray<UIView<UITextInput> *> *)deepInputTextViews:(UIView *)view{
    if(view.subviews.count <= 0){
        return [NSArray array];
    }else{
        NSMutableArray *textFiledViews = [NSMutableArray array];
        for (UIView *subView in view.subviews) {
            if([subView  conformsToProtocol:@protocol(UITextInput)]){
                [textFiledViews addObject:subView];
            }else{
                [textFiledViews addObjectsFromArray:[self deepInputTextViews:subView]];
            }
        }
        return textFiledViews;
    }
    
}
// MARK: 找出当前页面的第一响应者输入框
-(void)findFirstResponderTextFiledView{
    if(_firstTextFieldView && _firstTextFieldView.isFirstResponder){
        return;
    }else{
        __block WQTextFiledView *firstReponderView = nil;
        [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.isFirstResponder){
                firstReponderView = obj;
                *stop = YES;
            }
        }];
        _firstTextFieldView = firstReponderView;
    }
   
}
//MARK:找出当前输入框所在的window
-(UIWindow *)keyWindow
{
    if (_firstTextFieldView.window)
    {
        return _firstTextFieldView.window;
    }
    else
    {
        static UIWindow *_keyWindow = nil;
        
        /*  (Bug ID: #23, #25, #73)   */
        UIWindow *originalKeyWindow = [[UIApplication sharedApplication] keyWindow];
        
        //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
        if (originalKeyWindow != nil &&
            _keyWindow != originalKeyWindow)
        {
            _keyWindow = originalKeyWindow;
        }
        
        return _keyWindow;
    }
}

#pragma mark - UIKeyboad Notification methods
-(void)keyboardWillShow:(NSNotification *)aNotification{
 
    
    CGRect kbFrame = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self findFirstResponderTextFiledView];
    if(!_firstTextFieldView) return;
    
    NSInteger curve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _animationCurve = curve<<16;
    
    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (duration != 0.0)    _animationDuration = duration;
    
    UIWindow *keyWindow = [self keyWindow];
    
    CGRect textFieldViewRect = [[_firstTextFieldView superview] convertRect:_firstTextFieldView.frame toView:keyWindow];
    textFieldViewRect.size.height += _keyboardDistanceFromTextField;
    
     CGFloat offsetY = CGRectGetMinY(kbFrame) - CGRectGetMaxY(textFieldViewRect) - _keyboardDistanceFromTextField;
    
    if(_adjustScrollView){
        if(offsetY <= 0){
            [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                _adjustScrollView.contentOffset =CGPointMake(_adjustScrollView.contentOffset.x, _adjustScrollView.contentOffset.y - offsetY);
                //         [_adjustScrollView setContentOffset:CGPointMake(_adjustScrollView.contentOffset.x, _adjustScrollView.contentOffset.y - offsetY) animated:YES];
            } completion:NULL];
        }else{
            if(_adjustScrollView.contentOffset.y <= 0) return;
            [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                _adjustScrollView.contentOffset = CGPointMake(_adjustScrollView.contentOffset.x, MAX(_adjustScrollView.contentOffset.y - offsetY, 0));
//                [_adjustScrollView setContentOffset:CGPointMake(_adjustScrollView.contentOffset.x, MAX(_adjustScrollView.contentOffset.y - offsetY, 0))];
            } completion:NULL];
            
        }
    }else{
       
        //    CGRect intersectRect = CGRectIntersection(kbFrame, textFieldViewRect); //表示两者重叠的区域 (如果其中有个比较小另外一个比较大重叠区域的高度就是小的控件的高度)
        
        if(offsetY <= 0){//键盘遮盖了控件 需要上移
            [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                _adjustView.transform = CGAffineTransformTranslate(_adjustView.transform, 0,offsetY);
            } completion:NULL];
        }else{//键盘未遮盖控件 但是由于这里是显示键盘通知 所以需要把控件移到键盘上方最近的距离(这里暂时发现的情况是整个View上浮)
            
            //当View已经到顶了 还准备上浮的时候 就无需变动了
            if(CGAffineTransformEqualToTransform(_preTransform,_adjustView.transform)) return;
            
            [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                _adjustView.transform = CGAffineTransformTranslate(_adjustView.transform, 0,MIN(offsetY, fabs(_adjustView.transform.ty)));
            } completion:NULL];
        }
        
    }
    
}
-(void)keyboardWillHide:(NSNotification *)aNotification{
//    if(self.keyboardChangeing)return;

    NSInteger curve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _animationCurve = curve<<16;
    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (duration != 0.0)    _animationDuration = duration;
    if(_adjustScrollView){
        [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
            _adjustScrollView.contentOffset = _preContentOffset;
        } completion:NULL];
    }else{
        if(!CGAffineTransformEqualToTransform(_preTransform,_adjustView.transform)){
            [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                _adjustView.transform = _preTransform;
            } completion:^(BOOL finished) {
//                self.keyboardChangeing = NO;
            }];
        }
    }
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
