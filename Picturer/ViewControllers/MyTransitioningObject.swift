import Foundation
import UIKit

class MyTransitioningObject: NSObject, UIViewControllerAnimatedTransitioning {
    
    var _isLeftToRight:Bool=false
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Get the "from" and "to" views
        let fromView : UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView : UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        transitionContext.containerView()!.addSubview(fromView)
        transitionContext.containerView()!.addSubview(toView)
        
        //The "to" view with start "off screen" and slide left pushing the "from" view "off screen"
        
        var fromNewFrame:CGRect
        
        if _isLeftToRight {
            toView.frame = CGRectMake(-1*toView.frame.width, 0, toView.frame.width, toView.frame.height)
            fromNewFrame = CGRectMake(fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
        }else{
            toView.frame = CGRectMake(toView.frame.width, 0, toView.frame.width, toView.frame.height)
            fromNewFrame = CGRectMake(-1 * fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
        }
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView.frame = CGRectMake(0, 0, 320, 560)
            fromView.frame = fromNewFrame
            }) { (Bool) -> Void in
                // update internal view - must always be called
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.35
    }
}