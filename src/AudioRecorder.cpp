/****************************************************************************
**
** Copyright (C) 2017 Open Mobile Platform Ltd.
** Contact: Kirill Chuvilin <k.chuvilin@omprussia.ru>
**
** This file is a part of hybrid-dictaphone example project.
** See https://gitlab.com/sailfishos-examples for more examples.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Open Mobile Platform Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************/

#include "AudioRecorder.h"


AudioRecorder::AudioRecorder(QObject *parent) : QAudioRecorder(parent)
{
    this->configure("normal", "wav", "audio/PCM");
}

void AudioRecorder::configure(QString quality, QString containerFormat, QString codec) {
    if (quality == "low" || quality == "normal" || quality == "high") {
        QAudioEncoderSettings audioSettings;
        //audioSettings.setCodec("audio/PCM");
        audioSettings.setQuality(quality == "low" ? QMultimedia::LowQuality : quality == "normal" ? QMultimedia::NormalQuality : QMultimedia::HighQuality);
        this->setEncodingSettings(audioSettings);
    }
    if (containerFormat == "wav" || containerFormat == "ogg" || containerFormat == "avi") {
        this->setContainerFormat(containerFormat);
        foreach ( const QString &containerName, this->supportedAudioCodecs()) {
                //qInfo(containerName);
                QMessageLogger().debug() << containerName;
            }
    }
    if (codec == "audio/PCM" || codec == "audio/vorbis" || codec == "audio/speex" || codec == "audio/FLAC") {
        this->audioSettings().setCodec(codec);
    }
}
