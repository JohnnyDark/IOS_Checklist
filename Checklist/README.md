### TableView基础
##### 第一阶段
    定义基本数据模型，ChecklistItem
    重写tableView的datasource和delegate方法
    实现：数据显示，checkmark显示与隐藏，实现cell点击效果自动消失
    优化cell内容配置，configCheckMark， configText

##### 第二阶段
    添加navigationcontroller
        设置bar title
        显示large title
        添加navigation button实现添加items功能
    删除行
        添加swipe-to-delete功能
    添加 addItem screen
    转场segue建立及使用
    自定义navigation bar
    自定义view controller 类
    关闭large title显示

##### 第三阶段
    使用static table view cell
    禁止cell的可选择状态,storyboard中设置cell禁止被选中
    将键盘上done按钮的点击事件连接到done bar button 的action方法上
    设置键盘上done按钮的 auto-enable return key，输入框内容为空时键盘上done按钮不可点击
    成为textfield的代理，为textfiled处理任务，storyboard中将addviewcontroller设置为textfield的代理  
    从textfield中读取输入的内容
    设置屏幕显示后调用键盘
    设计textfield的UI
    处理键盘上 done 按钮
    设置不允许空输入
    配置done bar button在输入内容时的状态显示
    设置done bar button在刚进入添加界面时显示为可点击状态,storyboard中设置enable
    设置输入框中clear button的使用，以及点击clear button后disable doneBarbutton的状态

##### 第四阶段
    Document目录获取，plist文件的保存目录设置
    data model的结构化存储和读取

##### 第五阶段
    创建AllChecklist界面
    使用cell来带起prototype cell
    手动执行segue
    data model结构调整
    用代码来push出一个view controller
    1 通过storyboard来初始化目标view（每个view controller都持有对storyboard的引用: storyboard可选类型） controller(目标controller需要在storyboard中设置Storyboard Id)
        2 给目标view controller设置属性值
        3 navigationController?.pushViewController(_ controller:animated:)展示新的controller
    

##### 第六阶段
    1 保存数据策略 app即将进入后台运行模式或者即将停止运行时
