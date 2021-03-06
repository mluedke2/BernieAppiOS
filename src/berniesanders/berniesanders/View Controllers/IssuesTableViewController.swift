import UIKit

public class IssuesTableViewController: UITableViewController {
    private let issueRepository: IssueRepository!
    private let issueControllerProvider: IssueControllerProvider!
    private let theme: Theme!
    
    private var issues: Array<Issue>!
    
    public init(issueRepository: IssueRepository, issueControllerProvider: IssueControllerProvider, theme: Theme) {
        self.issueRepository = issueRepository
        self.issueControllerProvider = issueControllerProvider
        self.theme = theme
        self.issues = []
        
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.image = UIImage(named: "issuesTabBarIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let attributes = [
            NSFontAttributeName: theme.tabBarFont(),
            NSForegroundColorAttributeName: theme.tabBarTextColor()
        ]
        
        self.tabBarItem.setTitleTextAttributes(attributes, forState: .Normal)
        self.tabBarItem.setTitleTextAttributes(attributes, forState: .Selected)
        self.title = NSLocalizedString("Issues_tabBarTitle", comment: "")
        self.navigationItem.title = NSLocalizedString("Issues_navigationTitle", comment: "")
    }

    required public init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(IssueTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.issueRepository.fetchIssues({ (receivedIssues) -> Void in
            self.issues = receivedIssues
            self.tableView.reloadData()
            }, error: { (error) -> Void in
                // TODO: error handling.
        })
    }
    
    // MARK: UITableViewController
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issues.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IssueTableViewCell
        let issue = self.issues[indexPath.row]
        cell.titleLabel.text = issue.title
        cell.titleLabel.font = self.theme.issuesFeedTitleFont()
        cell.titleLabel.textColor = self.theme.issuesFeedTitleColor()
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var issue = self.issues[indexPath.row]
        let controller = self.issueControllerProvider.provideInstanceWithIssue(issue)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
