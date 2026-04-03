#include "save_file_info.h"

SaveFileInfo::SaveFileInfo(const QString &filePath, const QString &fileName, const int fileType, const int decryptType) {
    this->fileName = fileName;
    this->filePath = filePath;
    this->fileType = fileType;
    this->decryptType = decryptType;
}