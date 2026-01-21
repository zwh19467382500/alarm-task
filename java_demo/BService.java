package org.mycloud.provider.controller;

import lombok.Data;
import org.mycloud.provider.exception.CustomException;
import org.springframework.beans.BeanUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

public class BService {


    @Data
    class AlarmTaskReq{
        Integer id;
        String title;
        String type;
        String state;//闹钟状态，1开启 或 0关闭
        int timeInterval;// 统一时间间隔(分钟)
        boolean snoozeEnabled = false;
        boolean soundEnabled;
        String scheduleType;//循环周期类型
        int[] weekDays;//根据类型填充或自定义填充
        List<TimeNodeReq> timeNodes;//入参时间序列
        String startTime;//劝喝水开始时间
        String endTime;//劝喝水结束时间
    }

    @Data
    class AlarmTaskDO{
        Integer id;//数据库自增
        String title;//标题
        String type;//闹钟类型，起床了，上课铃，劝喝水
        String state;//闹钟状态，1开启 或 0关闭
        int timeInterval; // 统一时间间隔(分钟)，起床铃默认5分钟，上课铃没有这个属性，劝喝水受用户手动填写
        int snoozeTimeoutSeconds = 30;  // 起床闹钟的自动稍后提醒超时(秒)，默认值，暂不开放给ui进行设置
        boolean snoozeEnabled = false;//是否允许稍后提醒，设个属性的设置来自于稍后提醒的时间间隔，暂不允许修改。只有起床闹钟需要这个属性
        boolean soundEnabled;//是否响铃 ui默认允许，受用户手动修改影响
        String scheduleType;//循环周期类型 once仅一次/daily每天/workday周一至周五（工作日）/weekend周末/custom自定义
        int[] weekDays;//根据循环周期来填充或自定义填充
        List<TimeNodeDO> timeNodes;//数据库链接的时间序列
        String startTime;//劝喝水开始时间
        String endTime;//劝喝水结束时间
    }

    @Data
    class TimeNodeReq{
        int sort;//在单个闹钟任务的时间序列中的排序
        int relativeTime;//距离上一个时间节点的时间间隔
        boolean isHead;//是否为头节点
        String exTimeStr;//响铃的具体时间点，HH:mm格式
    }

    @Data
    class TimeNodeDO{
        String id;
        int sort;//在单个闹钟任务的时间序列中的排序
        int relativeTime;//距离上一个时间节点的时间间隔，主要用于修改或变更的时候重建具体时间点
        boolean isHead;//是否为头节点
        String exDateTimeStr;//响铃的具体日期和时间，yyyy-MM-dd HH:mm:ss格式
    }


    public void saveAlarm(AlarmTaskReq taskReq) throws ParseException {
        if(taskReq.getId()!=null){
            //根据id查询数据库，获取闹钟任务详情和已经保存的时间队列，调用根据闹钟任务id生成闹钟序列id的方法，删除所有向系统注册的闹钟，删除所有关联的时间节点数据，然后使用下面的流程对闹钟信息进行重新保存/计算/注册
            //todo 待完成
            //调用根据id查询闹钟任务的方法
            //获取全部的时间节点数据关联
            //取消注册所有的时间节点闹钟
            //删除数据库中的关系数据
        }

        //将提交过来的数据转换成数据库容许的格式进行保存，
        AlarmTaskDO alarmTaskDO = new AlarmTaskDO();
        BeanUtils.copyProperties(taskReq,alarmTaskDO);
        //按闹钟类型处理数据
        if(taskReq.type=="起床了"){
            alarmTaskDO.setSnoozeEnabled(true);
        }
        //按循环周期的选项，将具体的循环周期触发日填写到对象中
        if(taskReq.getScheduleType()=="仅一次"){
            alarmTaskDO.setWeekDays(null);
        } else if (taskReq.getScheduleType()=="每天"){
            alarmTaskDO.setWeekDays(new int[]{1,2,3,4,5,6,7});
        } else if (taskReq.getScheduleType()=="周一至周五"){
            alarmTaskDO.setWeekDays(new int[]{1,2,3,4,5});
        } else if (taskReq.getScheduleType()=="周末"){
            alarmTaskDO.setWeekDays(new int[]{6,7});
        } else if (taskReq.getScheduleType()=="自定义"){
            //由用户自己在ui中选择，程序中不做变更
            alarmTaskDO.setWeekDays(taskReq.getWeekDays());
        }else {
            throw new CustomException("不支持的循环周期类型");
        }

        //处理时间节点数据,并与闹钟任务进行关联
        List<TimeNodeDO> timeNodeDOS = calcutlateTimeNode(taskReq);
        //写入id
        timeNodeDOS.stream().forEach(t -> {
            t.setId(generateAlarmId(taskReq.getId(),t.getExDateTimeStr(),t.getSort()));
        });
        //todo 将这些节点序列存入数据库，然后与闹钟任务进行关联,此处调用基础方法中的存入数据库方法
        //todo 将这个时间序列注册进操作系统中，此处调用注册闹钟给操作系统的功能
        //todo 调用flutter中isar的保存和关联数据的方法
    }



    //计算精确的时间节点的方法
    public List<TimeNodeDO> calcutlateTimeNode(AlarmTaskReq taskReq) throws ParseException {
        //获取当前时间（保存闹钟的时间）
        int currWeekDayNum = getWeekDay();//获取当前日期所在的星期
        Map<String, Object> overLayANDNextActiveWeekDay = getOverLayANDNextActiveWeekDay(currWeekDayNum, taskReq.getWeekDays());//计算最近的一个需要响铃的日期
        boolean isOverlap = (boolean) overLayANDNextActiveWeekDay.get("isOverlap");//当日是否可以设置响铃
        String nextActiveWeekDay = (String) overLayANDNextActiveWeekDay.get("nextNum");//除了当日，下一个需要响铃的日期

        List<TimeNodeReq> timeNodeReqs = taskReq.getTimeNodes();
        String exTimeStr = timeNodeReqs.stream().filter(t -> t.isHead == true).findFirst().get().getExTimeStr();//获取头部节点的具体时间点，用来判断当日是否可以设置响铃
        int needToSetWeekDay = currWeekDayNum;//默认以当日作为需要设置闹钟的日期
        if(isOverlap){
            //当日在循环周期以内，进一步比较当前时间和序列的头部时间判断是否需要设置到当日
            //获取当前时间，只取时间信息并按上述方式进行格式化，然后比较两个时间
            Calendar now = Calendar.getInstance();
            // 创建当前时间的纯时间部分（去除日期影响）
            Calendar currentTime = Calendar.getInstance();
            currentTime.set(1970, Calendar.JANUARY, 1); // 设置为基准日期
            currentTime.set(Calendar.HOUR_OF_DAY, now.get(Calendar.HOUR_OF_DAY));
            currentTime.set(Calendar.MINUTE, now.get(Calendar.MINUTE));
            currentTime.set(Calendar.SECOND, now.get(Calendar.SECOND));
            currentTime.set(Calendar.MILLISECOND, 0);
            //格式化需要设置闹钟的时间字符串用于比较
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm");
            Date alarmTime = simpleDateFormat.parse(exTimeStr);
            // 创建闹钟时间的纯时间部分（去除日期影响）
            Calendar alarmTimeCalendar = Calendar.getInstance();
            alarmTimeCalendar.setTime(alarmTime);

            // 比较时间先后顺序
            if (currentTime.after(alarmTimeCalendar)) {
                // 当前时间已经过了闹钟设置时间，则使用下一个周期日期
                needToSetWeekDay = Integer.parseInt(nextActiveWeekDay);
            } else {
                // 当前时间还没到闹钟设置时间，可以在当日设置
                needToSetWeekDay = currWeekDayNum;
            }
        } else {
            //当日不包含在循环周期内，则直接指定为下一个需要设置闹钟的日期
            needToSetWeekDay = Integer.parseInt(nextActiveWeekDay);
        }

        //好，上面我们确定了应该进行设置的日期星期，接下来我们该或的时间序列了
        //首先，我们获取头部时间节点应该设置的日期
        String closestDateByWeekDay = getClosestDateByWeekDay(needToSetWeekDay);
        //然后我们获取需要设置的头部时间，即exTimeStr
        //然后我们可以调用生成时间序列的方法
        //此处，根据不同的闹钟类型，来生成闹钟间隔时间列表
        int[] interval = new int[]{};
        if(taskReq.getType()=="起床了"){
            //起床闹钟会预先注册7个节点，包含1个头部节点和6个稍后提醒节点，之间的间隔是固定的，共6个间隔
            //用for循环将时间间隔配置为6个元素的数组
            interval = new int[6];
            Arrays.fill(interval, taskReq.getTimeInterval());//将数组中所有元素设定为指定的时间间隔
        } else if (taskReq.getType()=="上课铃"){
            timeNodeReqs.sort(Comparator.comparingInt(TimeNodeReq::getSort));
            List<Integer> collect = timeNodeReqs.stream().map(t -> t.getRelativeTime()).collect(Collectors.toList());
            interval = collect.stream().mapToInt(Integer::intValue).toArray();
        } else if (taskReq.getType()=="劝喝水"){
            String startTime = taskReq.getStartTime();
            String endTime = taskReq.getEndTime();
            int timeInterval = taskReq.getTimeInterval();
            //根据起止时间段，搭配固定时间间隔生成时间序列
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            Date startDate = timeFormat.parse(startTime);
            Date endDate = timeFormat.parse(endTime);

            long startTimeMillis = startDate.getTime();
            long endTimeMillis = endDate.getTime();
            long diffMinutes;

            // 判断是否跨天
            if (endTimeMillis <= startTimeMillis) {
                // 跨天：结束时间被视为第二天的时间
                diffMinutes = (24 * 60 * 60 * 1000 - startTimeMillis + endTimeMillis) / (1000 * 60);
            } else {
                // 不跨天
                diffMinutes = (endTimeMillis - startTimeMillis) / (1000 * 60);
            }
            // 计算间隔数量（至少1个）
            int intervalCount = Math.max(1, (int)(diffMinutes / timeInterval));//todo 暂时先不处理 起止时间间隔小于设定的时间间隔 的场景

            // 创建间隔数组
            interval = new int[intervalCount];
            Arrays.fill(interval, timeInterval);
        } else {
            throw new CustomException("不支持的任务类型");
        }
        //我们获得了时间间隔数组，头部时间节点的日期，头部时间节点，然后可以开始生成包含日期的时间序列了
        List<TimeNodeDO> timeNodeDOList = getExDateTimeList(closestDateByWeekDay,exTimeStr,interval);
        return timeNodeDOList;
    }

    public int getWeekDay(){
        int weekDay = new Date().getDay();
        if (weekDay==0) weekDay=7;
        return weekDay;
    }

    public Map<String, Object> getOverLayANDNextActiveWeekDay(int currWeekDay,int[] weekDays){
//        获取最近的一个需要执行的循环周期中的星期数字的方法,
//        返回：当前日期是否与循环周期中的数字重叠的布尔值，和当前日期数字之外的下一个循环周期中的数字
//        入参1是代表当前日期在一个星期中的数字
//        入参2是一个序列，代表一个星期为周期中的循环日期
//                然后执行比较并返回
//        比如当前是1，循环周期是567，则需要返回{isoverlap = false,nextNum = 5}
//        比如当前是5，循环周期是123，则需要返回{isoverlap = false,nextNum = 1}
//        比如当前是5，循环周期是12345，则返回{isoverlap = true,nextNum = 1}
//        比如当前是6，循环周期是567，则返回{isoverlap = true,nextNum = 7}
//        比如当前是3，循环周期是127，则返回{isoverlap = false,nextNum = 7}
        // 判断当前星期是否在循环周期中
        boolean isOverlap = false;
        for (int weekDay : weekDays) {
            if (weekDay == currWeekDay) {
                isOverlap = true;
                break;
            }
        }

        // 对循环周期数组进行排序，确保按顺序查找下一个执行日
        int[] sortedWeekDays = weekDays.clone();
        Arrays.sort(sortedWeekDays);

        // 查找下一个执行日
        Integer nextNum = null;

        // 先查找大于当前星期的最小值
        for (int weekDay : sortedWeekDays) {
            if (weekDay > currWeekDay) {
                nextNum = weekDay;
                break;
            }
        }

        // 如果没找到，则取循环周期中的最小值（下周第一天）
        if (nextNum == null) {
            nextNum = sortedWeekDays[0];
        }

        // 构造返回结果
        Map<String, Object> result = new HashMap<>();
        result.put("isOverlap", isOverlap);
        result.put("nextNum", nextNum);

        return result;
    }

    public String getClosestDateByWeekDay(int weekDay){
        //根据传入的周几，返回最接近的日期，可以包含当日 格式yyyy-MM-dd
        // 参数校验
        if (weekDay < 1 || weekDay > 7) {
            throw new IllegalArgumentException("星期参数必须在1-7之间");
        }

        // 获取当前日期
        Calendar today = Calendar.getInstance();
        int currentWeekDay = today.get(Calendar.DAY_OF_WEEK);

        // Java中Calendar.DAY_OF_WEEK: 1=周日, 2=周一, ..., 7=周六
        // 转换为我们的标准: 1=周一, 2=周二, ..., 7=周日
        if (currentWeekDay == 1) {
            currentWeekDay = 7; // 周日转为7
        } else {
            currentWeekDay -= 1; // 其他日期减1
        }

        // 计算目标日期与当前日期的天数差
        int daysDiff;
        if (weekDay >= currentWeekDay) {
            // 如果目标星期大于等于当前星期，则在本周内
            daysDiff = weekDay - currentWeekDay;
        } else {
            // 如果目标星期小于当前星期，则在下周
            daysDiff = 7 - currentWeekDay + weekDay;
        }

        // 计算目标日期
        Calendar targetDate = (Calendar) today.clone();
        targetDate.add(Calendar.DAY_OF_YEAR, daysDiff);

        // 格式化并返回日期字符串
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(targetDate.getTime());
    }


    public List<TimeNodeDO> getExDateTimeList(String exDate,String exTime, int[] interval){
        //根据给定的日期，和给定的起始时间，按时间间隔列表，计算时间序列的功能
        //输入参数：exDate yyyy-MM-dd
        //输入参数：exTime HH:mm
        if (exDate == null || exTime == null || interval == null) {
            throw new IllegalArgumentException("参数不能为空");
        }

        try {
            // 解析输入日期和时间
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:00");

            Date date = dateFormat.parse(exDate);
            Date time = timeFormat.parse(exTime);

            // 合并日期和时间
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);

            Calendar timeCalendar = Calendar.getInstance();
            timeCalendar.setTime(time);

            calendar.set(Calendar.HOUR_OF_DAY, timeCalendar.get(Calendar.HOUR_OF_DAY));
            calendar.set(Calendar.MINUTE, timeCalendar.get(Calendar.MINUTE));
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MILLISECOND, 0);

            List<TimeNodeDO> result = new ArrayList<>();

            // 添加起始时间点
            TimeNodeDO timeNodeDO = new TimeNodeDO();
//            timeNodeDO.setId(null);//todo 调用生成id的方法
            timeNodeDO.setRelativeTime(0);//头部节点没有前一个
            timeNodeDO.setHead(true);
            timeNodeDO.setSort(0);//从0开始
            timeNodeDO.setExDateTimeStr(dateTimeFormat.format(calendar.getTime()));
            result.add(timeNodeDO);

            // 根据时间间隔列表依次计算后续时间点
            for (int i = 1; i <= interval.length; i++) {
                // 添加分钟间隔，每个时间间隔都是基于上一个时间节点进行累加
                calendar.add(Calendar.MINUTE, interval[i]);
                TimeNodeDO timeNodeDOLoop = new TimeNodeDO();
//                timeNodeDOLoop.setId(generateAlarmId());//调用生成id的方法
                timeNodeDOLoop.setRelativeTime(0);//头部节点没有前一个
                timeNodeDOLoop.setHead(true);
                timeNodeDOLoop.setSort(0);//从0开始
                timeNodeDOLoop.setExDateTimeStr(dateTimeFormat.format(calendar.getTime()));
                result.add(timeNodeDOLoop);
            }
            return result;
        } catch (Exception e) {
            throw new IllegalArgumentException("日期或时间格式不正确", e);
        }
    }


    public String generateAlarmId(int alarmTaskId, String targetDateTime, int sequenceIndex) {
        //这个方法在当前已经是哟闲了，不需要转义，直接调用同名方法即可，这里是指为了不报错写个一样的
        SimpleDateFormat sdfForGenerateAlarmId = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = null;
        try {
            date = sdfForGenerateAlarmId.parse(targetDateTime);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        //获取具体的年月日
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);

//        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1; // 注意：月份是从0开始计数的，所以需要加1
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        int dateCode = month * 100 + day; // MMDD格式

        // 编码规则：alarmTaskId * 100000 + MMDD * 10 + sequenceIndex
        String alarmId = alarmTaskId * 100000 + dateCode * 10 + sequenceIndex+"";
        return alarmId;
    }


    //==========================================================================================================

    /**
     * 切换闹钟任务状态
     * @param alarmTaskId
     */
    public void triggerAlarmTask(String alarmTaskId){
       //根据闹钟任务id获取闹钟任务详情，并获取闹钟关联的时间点列表
        AlarmTaskDO alarmTaskDO = new AlarmTaskDO();//使用新建代表从数据库中查出来的闹钟任务
        List<TimeNodeDO> timeNodeDOList = new ArrayList<>();//使用新建代表从数据库中查出来的时间点列表
        if(alarmTaskDO.getState().equals("1")){//闹钟任务当前已开启
            //那就给他改成关闭
            alarmTaskDO.setState("0");
            //调用取消注册时间节点的方法
        }else {
            //那就给他改成开启
            alarmTaskDO.setState("1");
            //调用注册时间节点的方法
        }
    }


    public void deleteAlarmTask(String alarmTaskId){
        //查找所有关联这个闹钟任务的时间点
        //按timeNode的id从系统中取消注册这些时间点闹钟
        //删除这些timeNode
        //删除alarmTask
    }

    public List<AlarmTaskDO> getAlarmTaskList(){
        //获取所有闹钟任务列表
        //返回给前端
        return null;//这里使用null来代替返回结果，避免伪代码报错
    }

    public AlarmTaskDO getAlarmTaskDetail(String alarmTaskId){
        //获取指定闹钟任务详情
        //获取相关的timenode列表
        //全部返回给前端编辑页面
        return null;//这里使用null来代替返回结果，避免伪代码报错
    }

    public Long calculateAlarmTaskPointCountdown(String alarmTaskId){
        //获取闹钟任务详情
        //获取闹钟任务关联的所有时间点
        //获取当前时间
        //排序时间点序列
        //依次与当前时间进行比较，找到第一个大于当前时间的时间点，并计算差值
//        返回差值，让前端ui计算为剩余的时间
        return null;
    }




}
