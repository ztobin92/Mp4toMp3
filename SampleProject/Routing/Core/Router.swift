import UIKit

protocol RouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }  // Keep track of the current view controller
    var openTransition: Transition? { get set }        // Keep track of the current transition
    func open(_ viewController: UIViewController, transition: Transition)
    func close(completion: (() -> Void)?)
}

class Router: RouterProtocol {

    weak var viewController: UIViewController?  // Store a weak reference to the view controller
    var openTransition: Transition?  // Store the transition type

    // Open method to present a new view controller with a transition
    func open(_ viewController: UIViewController, transition: Transition) {
        transition.viewController = self.viewController  // Set the current view controller in transition
        transition.open(viewController)  // Open the new view controller with the transition
    }

    // Close method with optional completion handler for closing the current view controller
    func close(completion: (() -> Void)? = nil) {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)  // Use the transition to close the view controller
        completion?()  // Trigger completion handler if provided
    }

    deinit {
        debugPrint("deinit \(self)")  // Debug print for deinitialization
    }
}
