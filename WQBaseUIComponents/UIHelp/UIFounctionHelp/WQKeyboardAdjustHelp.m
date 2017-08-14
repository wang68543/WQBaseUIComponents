//
//  WQKeyboardManager.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/2/28.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQKeyboardAdjustHelp.h"
#import <objc/message.h>
@implementation UIView(WQTextInput)

static char *const kBindKey = "bidnKey";

-(void)setDataKey:(NSString *)dataKey{
    if(dataKey){
        objc_setAssociatedObject(self, kBindKey, dataKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}
-(NSString *)dataKey{
    return objc_getAssociatedObject(self,kBindKey);
}

-(void)setWq_text:(NSString *)wq_text{
    if([self isKindOfClass:[UITextField class]]){
        UITextField *tf = (UITextField *)self;
        tf.text = wq_text;
    }else if([self isKindOfClass:[UITextView class]]){
        UITextView *tv = (UITextView *)self;
        tv.text = wq_text;
    }
}
-(NSString *)wq_text{
    NSString * _wq_text;
    if([self isKindOfClass:[UITextField class]]){
        UITextField *tf = (UITextField *)self;
        _wq_text = tf.text;
    }else if([self isKindOfClass:[UITextView class]]){
        UITextView *tv = (UITextView *)self;
        _wq_text = tv.text;
    }
    if(!_wq_text){
        _wq_text = @"";
    }
    return _wq_text;
}

@end

@interface WQKeyboardAdjustHelp()<UITextViewDelegate,UITextFieldDelegate>
//@property (assign ,nonatomic) BOOL keyboardChangeing;
@property (strong ,nonatomic) UITapGestureRecognizer *tapGR;

@end
@implementation WQKeyboardAdjustHelp{
//    NSInteger _excludeTag;
//    NSArray <WQTextFiledView *> *_textFieldViews;
    WQTextFiledView* _firstTextFieldView;//第一响应者
//    BOOL hasConfigDelegates;
    UIView *_lastView;
    UIView *_adjustView;
    UIScrollView *_adjustScrollView;
    CGPoint _preContentOffset;//记录scollView初始的offset
    CGAffineTransform _preTransform;
   
    UIView *_gestureView;
    
}
+(instancetype)keyboardAdjustHelpWithView:(UIView *)view{
    return [self keyboardAdjustWithMoveView:view gestureRecognizerView:view];
}
+(instancetype)keyboardAdjustWithMoveView:(UIView *)moveView gestureRecognizerView:(UIView *)gestureView{
    return [[self alloc] initWithMoveView:moveView gestureRecognizerView:gestureView];
}
-(instancetype)initWithMoveView:(UIView *)moveView gestureRecognizerView:(UIView *)gestureView{
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
//TODO: 最后确认提交的按钮
-(void)setLastConfirmButton:(UIButton *)lastConfirmButton{
    _lastConfirmButton = lastConfirmButton;
    lastConfirmButton.enabled = [self canEnableLastConfirmButton];
}
//TODO: 决定最后提交的按钮是否能够提交
- (BOOL)canEnableLastConfirmButton{
    if(!self.lastConfirmButton){
        return NO;
    }
      BOOL canEnableBtn = YES;
    if([self.delegate respondsToSelector:@selector(canEnableConfirmButtonInView)]){
        canEnableBtn = [self.delegate canEnableConfirmButtonInView];
    }
    //如果代理不让启用 就直接返回
    if (!canEnableBtn) return canEnableBtn;

    canEnableBtn = [self textFieldViewsHasText];
    return canEnableBtn;
}

//TODO: 当前所有输入框是否有内容
- (BOOL)textFieldViewsHasText{
     __block BOOL hasText = YES;
    [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj hasText]){
            hasText = NO;
            *stop = YES;
        }
    }];
    return hasText;
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
         [obj setValue:weakSelf forKey:@"delegate"];
        
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    [self changeFirstResponder:textField];
#pragma clang diagnostic pop
    return NO;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(adjustShouldBeignEditing:)]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        return  [self.delegate adjustShouldBeignEditing:textField];
#pragma clang diagnostic pop
    }else{
        return YES;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(self.lastConfirmButton){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.lastConfirmButton.enabled = [self canEnableLastConfirmButton];
        });
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([self.delegate respondsToSelector:@selector(adjustShouldBeignEditing:)]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        return  [self.delegate adjustShouldBeignEditing:textView];
#pragma clang diagnostic pop
    }else{
        return YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        [self changeFirstResponder:textView];
#pragma clang diagnostic pop
        return NO;
    }else{
       
        return YES;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    self.lastConfirmButton.enabled = [self canEnableLastConfirmButton];
    
}

-(void)changeFirstResponder:(WQTextFiledView *)textFiledView{
    NSInteger index = [_textFieldViews indexOfObject:textFiledView];
   
    if(index < _textFieldViews.count -1 && index >= 0){
        WQTextFiledView* inputView = _textFieldViews[index + 1];
           BOOL canBecomFirst = YES;
            if([self.delegate respondsToSelector:@selector(adjustShouldNext:preTFView:)]){
               canBecomFirst = [self.delegate adjustShouldNext:inputView preTFView:textFiledView];
            }
        if(canBecomFirst){
           [inputView becomeFirstResponder];
        }else{
          [textFiledView resignFirstResponder];
        }
    }else{
       [textFiledView resignFirstResponder];
        if([self.delegate respondsToSelector:@selector(adjustShouldDone:content:)]){
            [self.delegate adjustShouldDone:textFiledView content:[textFiledView valueForKey:@"text"]];
        }
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

//MARK: --找出所有的输入框 并按照坐标排序
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
                if(([subView isKindOfClass:[UITextField class]] && [(UITextField *)subView isEnabled]) ||([subView isKindOfClass:[UITextView class]] && [(UITextView *)subView isEditable]) ){//可编辑的编辑框才加入数组中
                     [textFiledViews addObject:subView];
                }
               
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
//MARK: -- -实时查找当前的 第一响应者
- (UIView *)dynamicFindCurrentFirstReponder:(UIView *)view{
    if ([view conformsToProtocol:@protocol(UITextInput)] && view.isFirstResponder) {//(UITextField *)
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView  *tf = [self dynamicFindCurrentFirstReponder:subview];
        if (tf) {
            return tf;
        }
    }
    return nil;

}
//MARK:-- -找出当前输入框所在的window
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
    if(!_firstTextFieldView) {//后来添加上去的
        _firstTextFieldView = (WQTextFiledView *)[self dynamicFindCurrentFirstReponder:_lastView];
        if (!_firstTextFieldView) return;
    }
    
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
            [_adjustScrollView setContentOffset:CGPointMake(_adjustScrollView.contentOffset.x, _adjustScrollView.contentOffset.y - offsetY) animated:YES];
            
//            [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
//                _adjustScrollView.contentOffset =CGPointMake(_adjustScrollView.contentOffset.x, _adjustScrollView.contentOffset.y - offsetY);
//            } completion:NULL];
        }else{
            if(_adjustScrollView.contentOffset.y <= 0) return;
             [_adjustScrollView setContentOffset:CGPointMake(_adjustScrollView.contentOffset.x, MAX(_adjustScrollView.contentOffset.y - offsetY, 0))];
//            [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
//                _adjustScrollView.contentOffset = CGPointMake(_adjustScrollView.contentOffset.x, MAX(_adjustScrollView.contentOffset.y - offsetY, 0));
//            } completion:NULL];
            
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
#pragma mark -- 外界工具方法 
/** 按照顺序配置绑定的key */
- (void)configTFViewsKey:(NSArray *)dataKeys{
    if(![dataKeys isKindOfClass:[NSArray class]] || dataKeys.count != _textFieldViews.count) return;
    [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.dataKey = [dataKeys objectAtIndex:idx];
    }];
}
/** 获取当前代理里面所有输入框的值 (键值为绑定的key) */
-(NSDictionary *)allTFViewsValue{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.dataKey.length > 0){
            [values setValue:obj.wq_text forKey:obj.dataKey];
        }
    }];
    return [values copy];
}
/** 设置 输入框的值 按照绑定的键值 */
-(void)setAllTFViewsValueWithDic:(NSDictionary *)dic{
    if(![dic isKindOfClass:[NSDictionary class]]) return;
    [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.dataKey.length > 0){
             [self setTFView:obj value:[dic objectForKey:obj.dataKey]];
        }
    }];
}
/** 设置 输入框的值 按坐标的排列顺序 */
-(void)setAllTFViewsValueWithArray:(NSArray *)values{
    if(![values isKindOfClass:[NSArray class]] || values.count != _textFieldViews.count) return;
    [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setTFView:obj value:values[idx]];
    }];
}
/** 设置 输入框的值 按按照模型来获取 */
-(void)setAllTFViewsValueWithModel:(id)instance{
    [_textFieldViews enumerateObjectsUsingBlock:^(WQTextFiledView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.dataKey.length > 0){
            [self setTFView:obj value:[instance valueForKey:obj.dataKey]];
        }

    }];
}
- (void)setTFView:(WQTextFiledView *)tfView value:(NSString *)value{
    NSString *textValue = value;
    if([self.delegate respondsToSelector:@selector(shouldSetTFView:value:)]){
        textValue = [self.delegate shouldSetTFView:tfView value:value];
    }
    tfView.wq_text = textValue;
}
#pragma mark --
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
