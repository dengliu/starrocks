// This file is made available under Elastic License 2.0.
// This file is based on code available under the Apache license here:
//   https://github.com/apache/incubator-doris/blob/master/fe/fe-core/src/main/java/org/apache/doris/analysis/AlterViewStmt.java

// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package com.starrocks.analysis;

import com.starrocks.sql.ast.AstVisitor;
import com.starrocks.sql.ast.QueryStatement;

import java.util.List;

// Alter view statement
public class AlterViewStmt extends BaseViewStmt {

    public AlterViewStmt(TableName tbl, List<ColWithComment> cols, QueryStmt queryStmt) {
        super(tbl, cols, queryStmt);
    }

    public AlterViewStmt(TableName tbl, List<ColWithComment> cols, QueryStatement queryStatement) {
        super(tbl, cols, queryStatement);
    }

    public TableName getTbl() {
        return tableName;
    }

    @Override
    public String toSql() {
        StringBuilder sb = new StringBuilder();
        sb.append("ALTER VIEW ");
        sb.append(tableName.toSql()).append("\n");
        if (cols != null) {
            sb.append("(\n");
            for (int i = 0; i < cols.size(); i++) {
                if (i != 0) {
                    sb.append(",\n");
                }
                sb.append("  ").append(cols.get(i).getColName());
            }
            sb.append("\n)");
        }
        sb.append("\n");
        sb.append("AS ").append(viewDefStmt.toSql()).append("\n");
        return sb.toString();
    }

    @Override
    public String toString() {
        return toSql();
    }

    @Override
    public <R, C> R accept(AstVisitor<R, C> visitor, C context) {
        return visitor.visitAlterViewStatement(this, context);
    }

    @Override
    public boolean isSupportNewPlanner() {
        return true;
    }
}
