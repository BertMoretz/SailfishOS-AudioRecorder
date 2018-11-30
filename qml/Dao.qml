import QtQuick 2.6
import QtQuick.LocalStorage 2.0
import QtMultimedia 5.6

Item {
    property var defaultSaveLocation: "/home/nemo/Documents" //StandardPaths.documents

    property var database
    property var recs

    Component.onCompleted: {
        database = LocalStorage.openDatabaseSync("records", "1.0")
        database.transaction(function(tx) {
//            tx.executeSql("DROP TABLE Settings");return
            tx.executeSql("CREATE TABLE IF NOT EXISTS Records(
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 Name TEXT,
                 Note TEXT,
                 Path TEXT)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS Settings(
                 Key TEXT,
                 Value TEXT)");
            if (tx.executeSql("SELECT COUNT(*) as count FROM Settings").rows.item(0).count === 0) {
                tx.executeSql("INSERT INTO Settings (Key, Value)
                    VALUES ('Quality', 'normal'), ('ContainerFormat', 'wav'), ('SaveLocation', ?), ('Codec', 'audio/PCM')", [defaultSaveLocation]);
            }
            readSettings(function(settings) {
                if (!settings.Quality || !settings.ContainerFormat || !settings.SaveLocation || !settings.Codec) {
                    tx.executeSql("DELETE FROM Settings");
                    tx.executeSql("INSERT INTO Settings (Key, Value)
                        VALUES ('Quality', ''), ('ContainerFormat', ''), ('SaveLocation', ?), ('Codec', '')", [defaultSaveLocation]);
                    writeSettings({Quality: "normal", ContainerFormat: "wav", SaveLocation: defaultSaveLocation, Codec: "audio/PCM"});
                }
            });
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

    function updateRecord(id, Name, Note,cb) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("UPDATE Records SET Name = ?, Note = ?
                                 WHERE id = ?", [Name, Note, id]);
            cb && cb()
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

    function removeRecord(id,cb) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("DELETE FROM Records WHERE id = ?", [id]);
            cb && cb()
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

    function readSettings(callback) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.readTransaction(function(tx) {
            var result = tx.executeSql("SELECT * FROM Settings;");
            var settings = new Object();
            for (var i = 0; i < result.rows.length; i++) {
                var item = result.rows.item(i);
                settings[item.Key] = item.Value;
            }
            callback(settings);
        });
    }

    function writeSettings(settings) {
        database = LocalStorage.openDatabaseSync("records", "1.0");
        database.transaction(function(tx) {
            for (var key in settings) {
                tx.executeSql("UPDATE Settings SET Value = ? WHERE Key = ?", [settings[key], key]);
            }
        });
    }

}

