import QtQuick 2.0
import QtQuick.LocalStorage 2.0


Item {

    property var database
    property var recs

    Component.onCompleted: {
        database = LocalStorage.openDatabaseSync("records", "1.0")
        database.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS Records(
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 Name TEXT,
                 Note TEXT,
                 Path TEXT)");
        });
        //updateStatisticsValue();
    }


    function createRecord(Name, Note, Path) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("INSERT INTO Records(Name, Note, Path)
                                VALUES(?, ?, ?)", [Name, Note, Path]);
        });
        //updateStatisticsValue();
    }

    function updateRecord(id, Name, Note) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("UPDATE Records SET Name = ?, Note = ?
                                 WHERE id = ?", [Name, Note, id]);
        });
        //updateStatisticsValue();
    }

    function updateRecordPath(id, Name, Note, Path) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("UPDATE Records SET Name = ?, Note = ?, Path = ?
                                 WHERE id = ?", [Name, Note, Path, id]);
        });
        //updateStatisticsValue();
    }

    function removeRecord(id) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("DELETE FROM Records WHERE id = ?", [id]);
        });
        //updateStatisticsValue();
    }

    function removeRecords() {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("DELETE FROM Records");
        });
        //updateStatisticsValue();
    }

    function retrieveRecordById(id, callback) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.readTransaction(function(tx) {
            var result = tx.executeSql("SELECT * FROM Records WHERE id = ?", [id]);
            callback(result.rows.item(0));
        });
    }

    function retrieveRecords(callback) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.readTransaction(function(tx) {
            var result = tx.executeSql("SELECT * FROM Records;");
            callback(result.rows)
        });
    }
}

