//: A UIKit based Playground to present user interface
  
import UIKit
import PlaygroundSupport

class myViewController : UIViewController {
	let points: [CGPoint] = [CGPoint(x: 40, y: 40), CGPoint(x: 200, y: 40), CGPoint(x: 40, y: 200), CGPoint(x: 200, y: 200)]
	
	// Create points
	func createPointsForClusters() -> [UIView] {
		let pointsForCluster: [UIView] = points.map{ point in
			let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
			view.center = point
			view.backgroundColor = .red
			view.layer.cornerRadius = 15
			return view
		}
		return pointsForCluster
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let pointsForCluster = createPointsForClusters()
		pointsForCluster.forEach{ view.addSubview($0) }//drawPoints
		
		createClusterView()
	}

    override func loadView() {
        let view = UIView()
		view.backgroundColor = .lightGray
        self.view = view
    }
	
	func createClusterView() {
		//Create clusterView
		let clusterView = UIView(frame: CGRect(origin: .zero, size: calculateSizeOfClusterView()))
		
		clusterView.center = clusterCenterPoint()
		clusterView.backgroundColor = .blue
		clusterView.layer.cornerRadius = findMaxDistance()
		
		view.addSubview(clusterView)
		view.sendSubview(toBack: clusterView)
	}
	
	//MARK: Cluster work
	// Find center point
	func clusterCenterPoint() -> CGPoint {
		let count: CGFloat = CGFloat(points.count)
		let deltaX = points.map{ $0.x }.reduce(0, +) / count
		let deltaY = points.map{ $0.y }.reduce(0, +) / count
		return CGPoint(x: deltaX, y: deltaY)
	}
	
	// Find max distance of note from center
	func findMaxDistance() -> CGFloat {
		func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
			let xDist = a.x - b.x
			let yDist = a.y - b.y
			return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
		}
		let centerPoint = clusterCenterPoint()
		return points.map{ distance(centerPoint, $0) }.reduce(0){ max($0, $1) }
	}
	
	// Calculate the size of the Cluster View
	func calculateSizeOfClusterView() -> CGSize {
		let radius = findMaxDistance()
		let diameter: CGFloat = radius * 2
		let buffer: CGFloat = 50
		return CGSize(width: diameter + buffer, height: diameter + buffer)
	}
}

PlaygroundPage.current.liveView = myViewController()
