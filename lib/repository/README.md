# Repository Layer - 数据访问层

## 职责
处理数据访问逻辑，管理领域内的数据操作。

## 主要功能
- 数据库CRUD操作
- 领域特定的查询逻辑
- 数据完整性保证
- 领域业务规则验证
- 聚合根操作

## 设计原则
- 每个Repository负责一个领域
- 只包含领域内的数据操作逻辑
- 不跨领域调用其他Repository
- 确保数据一致性

## 命名规范
- `{domain}_repository.dart` 格式
- 例如：`alarm_repository.dart`, `user_repository.dart`