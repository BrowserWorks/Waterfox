/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.android.exoplayer2.extractor.ts;

import android.support.annotation.IntDef;
import android.util.SparseArray;
import android.util.SparseBooleanArray;
import android.util.SparseIntArray;
import com.google.android.exoplayer2.C;
import com.google.android.exoplayer2.extractor.Extractor;
import com.google.android.exoplayer2.extractor.ExtractorInput;
import com.google.android.exoplayer2.extractor.ExtractorOutput;
import com.google.android.exoplayer2.extractor.ExtractorsFactory;
import com.google.android.exoplayer2.extractor.PositionHolder;
import com.google.android.exoplayer2.extractor.SeekMap;
import com.google.android.exoplayer2.extractor.TrackOutput;
import com.google.android.exoplayer2.extractor.ts.DefaultTsPayloadReaderFactory.Flags;
import com.google.android.exoplayer2.extractor.ts.TsPayloadReader.DvbSubtitleInfo;
import com.google.android.exoplayer2.extractor.ts.TsPayloadReader.EsInfo;
import com.google.android.exoplayer2.extractor.ts.TsPayloadReader.TrackIdGenerator;
import com.google.android.exoplayer2.util.Assertions;
import com.google.android.exoplayer2.util.ParsableBitArray;
import com.google.android.exoplayer2.util.ParsableByteArray;
import com.google.android.exoplayer2.util.TimestampAdjuster;
import com.google.android.exoplayer2.util.Util;
import java.io.IOException;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Facilitates the extraction of data from the MPEG-2 TS container format.
 */
public final class TsExtractor implements Extractor {

  /**
   * Factory for {@link TsExtractor} instances.
   */
  public static final ExtractorsFactory FACTORY = new ExtractorsFactory() {

    @Override
    public Extractor[] createExtractors() {
      return new Extractor[] {new TsExtractor()};
    }

  };

  /**
   * Modes for the extractor.
   */
  @Retention(RetentionPolicy.SOURCE)
  @IntDef({MODE_NORMAL, MODE_SINGLE_PMT, MODE_HLS})
  public @interface Mode {}

  /**
   * Behave as defined in ISO/IEC 13818-1.
   */
  public static final int MODE_NORMAL = 0;
  /**
   * Assume only one PMT will be contained in the stream, even if more are declared by the PAT.
   */
  public static final int MODE_SINGLE_PMT = 1;
  /**
   * Enable single PMT mode, map {@link TrackOutput}s by their type (instead of PID) and ignore
   * continuity counters.
   */
  public static final int MODE_HLS = 2;

  public static final int TS_STREAM_TYPE_MPA = 0x03;
  public static final int TS_STREAM_TYPE_MPA_LSF = 0x04;
  public static final int TS_STREAM_TYPE_AAC = 0x0F;
  public static final int TS_STREAM_TYPE_AC3 = 0x81;
  public static final int TS_STREAM_TYPE_DTS = 0x8A;
  public static final int TS_STREAM_TYPE_HDMV_DTS = 0x82;
  public static final int TS_STREAM_TYPE_E_AC3 = 0x87;
  public static final int TS_STREAM_TYPE_H262 = 0x02;
  public static final int TS_STREAM_TYPE_H264 = 0x1B;
  public static final int TS_STREAM_TYPE_H265 = 0x24;
  public static final int TS_STREAM_TYPE_ID3 = 0x15;
  public static final int TS_STREAM_TYPE_SPLICE_INFO = 0x86;
  public static final int TS_STREAM_TYPE_DVBSUBS = 0x59;

  private static final int TS_PACKET_SIZE = 188;
  private static final int TS_SYNC_BYTE = 0x47; // First byte of each TS packet.
  private static final int TS_PAT_PID = 0;
  private static final int MAX_PID_PLUS_ONE = 0x2000;

  private static final long AC3_FORMAT_IDENTIFIER = Util.getIntegerCodeForString("AC-3");
  private static final long E_AC3_FORMAT_IDENTIFIER = Util.getIntegerCodeForString("EAC3");
  private static final long HEVC_FORMAT_IDENTIFIER = Util.getIntegerCodeForString("HEVC");

  private static final int BUFFER_PACKET_COUNT = 5; // Should be at least 2
  private static final int BUFFER_SIZE = TS_PACKET_SIZE * BUFFER_PACKET_COUNT;

  @Mode private final int mode;
  private final List<TimestampAdjuster> timestampAdjusters;
  private final ParsableByteArray tsPacketBuffer;
  private final ParsableBitArray tsScratch;
  private final SparseIntArray continuityCounters;
  private final TsPayloadReader.Factory payloadReaderFactory;
  private final SparseArray<TsPayloadReader> tsPayloadReaders; // Indexed by pid
  private final SparseBooleanArray trackIds;

  // Accessed only by the loading thread.
  private ExtractorOutput output;
  private int remainingPmts;
  private boolean tracksEnded;
  private TsPayloadReader id3Reader;

  public TsExtractor() {
    this(0);
  }

  /**
   * @param defaultTsPayloadReaderFlags A combination of {@link DefaultTsPayloadReaderFactory}
   *     {@code FLAG_*} values that control the behavior of the payload readers.
   */
  public TsExtractor(@Flags int defaultTsPayloadReaderFlags) {
    this(MODE_NORMAL, new TimestampAdjuster(0),
        new DefaultTsPayloadReaderFactory(defaultTsPayloadReaderFlags));
  }

  /**
   * @param mode Mode for the extractor. One of {@link #MODE_NORMAL}, {@link #MODE_SINGLE_PMT}
   *     and {@link #MODE_HLS}.
   * @param timestampAdjuster A timestamp adjuster for offsetting and scaling sample timestamps.
   * @param payloadReaderFactory Factory for injecting a custom set of payload readers.
   */
  public TsExtractor(@Mode int mode, TimestampAdjuster timestampAdjuster,
      TsPayloadReader.Factory payloadReaderFactory) {
    this.payloadReaderFactory = Assertions.checkNotNull(payloadReaderFactory);
    this.mode = mode;
    if (mode == MODE_SINGLE_PMT || mode == MODE_HLS) {
      timestampAdjusters = Collections.singletonList(timestampAdjuster);
    } else {
      timestampAdjusters = new ArrayList<>();
      timestampAdjusters.add(timestampAdjuster);
    }
    tsPacketBuffer = new ParsableByteArray(BUFFER_SIZE);
    tsScratch = new ParsableBitArray(new byte[3]);
    trackIds = new SparseBooleanArray();
    tsPayloadReaders = new SparseArray<>();
    continuityCounters = new SparseIntArray();
    resetPayloadReaders();
  }

  // Extractor implementation.

  @Override
  public boolean sniff(ExtractorInput input) throws IOException, InterruptedException {
    byte[] buffer = tsPacketBuffer.data;
    input.peekFully(buffer, 0, BUFFER_SIZE);
    for (int j = 0; j < TS_PACKET_SIZE; j++) {
      for (int i = 0; true; i++) {
        if (i == BUFFER_PACKET_COUNT) {
          input.skipFully(j);
          return true;
        }
        if (buffer[j + i * TS_PACKET_SIZE] != TS_SYNC_BYTE) {
          break;
        }
      }
    }
    return false;
  }

  @Override
  public void init(ExtractorOutput output) {
    this.output = output;
    output.seekMap(new SeekMap.Unseekable(C.TIME_UNSET));
  }

  @Override
  public void seek(long position, long timeUs) {
    int timestampAdjustersCount = timestampAdjusters.size();
    for (int i = 0; i < timestampAdjustersCount; i++) {
      timestampAdjusters.get(i).reset();
    }
    tsPacketBuffer.reset();
    continuityCounters.clear();
    // Elementary stream readers' state should be cleared to get consistent behaviours when seeking.
    resetPayloadReaders();
  }

  @Override
  public void release() {
    // Do nothing
  }

  @Override
  public int read(ExtractorInput input, PositionHolder seekPosition)
      throws IOException, InterruptedException {
    byte[] data = tsPacketBuffer.data;
    // Shift bytes to the start of the buffer if there isn't enough space left at the end
    if (BUFFER_SIZE - tsPacketBuffer.getPosition() < TS_PACKET_SIZE) {
      int bytesLeft = tsPacketBuffer.bytesLeft();
      if (bytesLeft > 0) {
        System.arraycopy(data, tsPacketBuffer.getPosition(), data, 0, bytesLeft);
      }
      tsPacketBuffer.reset(data, bytesLeft);
    }
    // Read more bytes until there is at least one packet size
    while (tsPacketBuffer.bytesLeft() < TS_PACKET_SIZE) {
      int limit = tsPacketBuffer.limit();
      int read = input.read(data, limit, BUFFER_SIZE - limit);
      if (read == C.RESULT_END_OF_INPUT) {
        return RESULT_END_OF_INPUT;
      }
      tsPacketBuffer.setLimit(limit + read);
    }

    // Note: see ISO/IEC 13818-1, section 2.4.3.2 for detailed information on the format of
    // the header.
    final int limit = tsPacketBuffer.limit();
    int position = tsPacketBuffer.getPosition();
    while (position < limit && data[position] != TS_SYNC_BYTE) {
      position++;
    }
    tsPacketBuffer.setPosition(position);

    int endOfPacket = position + TS_PACKET_SIZE;
    if (endOfPacket > limit) {
      return RESULT_CONTINUE;
    }

    tsPacketBuffer.skipBytes(1);
    tsPacketBuffer.readBytes(tsScratch, 3);
    if (tsScratch.readBit()) { // transport_error_indicator
      // There are uncorrectable errors in this packet.
      tsPacketBuffer.setPosition(endOfPacket);
      return RESULT_CONTINUE;
    }
    boolean payloadUnitStartIndicator = tsScratch.readBit();
    tsScratch.skipBits(1); // transport_priority
    int pid = tsScratch.readBits(13);
    tsScratch.skipBits(2); // transport_scrambling_control
    boolean adaptationFieldExists = tsScratch.readBit();
    boolean payloadExists = tsScratch.readBit();

    // Discontinuity check.
    boolean discontinuityFound = false;
    int continuityCounter = tsScratch.readBits(4);
    if (mode != MODE_HLS) {
      int previousCounter = continuityCounters.get(pid, continuityCounter - 1);
      continuityCounters.put(pid, continuityCounter);
      if (previousCounter == continuityCounter) {
        if (payloadExists) {
          // Duplicate packet found.
          tsPacketBuffer.setPosition(endOfPacket);
          return RESULT_CONTINUE;
        }
      } else if (continuityCounter != (previousCounter + 1) % 16) {
        discontinuityFound = true;
      }
    }

    // Skip the adaptation field.
    if (adaptationFieldExists) {
      int adaptationFieldLength = tsPacketBuffer.readUnsignedByte();
      tsPacketBuffer.skipBytes(adaptationFieldLength);
    }

    // Read the payload.
    if (payloadExists) {
      TsPayloadReader payloadReader = tsPayloadReaders.get(pid);
      if (payloadReader != null) {
        if (discontinuityFound) {
          payloadReader.seek();
        }
        tsPacketBuffer.setLimit(endOfPacket);
        payloadReader.consume(tsPacketBuffer, payloadUnitStartIndicator);
        Assertions.checkState(tsPacketBuffer.getPosition() <= endOfPacket);
        tsPacketBuffer.setLimit(limit);
      }
    }

    tsPacketBuffer.setPosition(endOfPacket);
    return RESULT_CONTINUE;
  }

  // Internals.

  private void resetPayloadReaders() {
    trackIds.clear();
    tsPayloadReaders.clear();
    SparseArray<TsPayloadReader> initialPayloadReaders =
        payloadReaderFactory.createInitialPayloadReaders();
    int initialPayloadReadersSize = initialPayloadReaders.size();
    for (int i = 0; i < initialPayloadReadersSize; i++) {
      tsPayloadReaders.put(initialPayloadReaders.keyAt(i), initialPayloadReaders.valueAt(i));
    }
    tsPayloadReaders.put(TS_PAT_PID, new SectionReader(new PatReader()));
    id3Reader = null;
  }

  /**
   * Parses Program Association Table data.
   */
  private class PatReader implements SectionPayloadReader {

    private final ParsableBitArray patScratch;

    public PatReader() {
      patScratch = new ParsableBitArray(new byte[4]);
    }

    @Override
    public void init(TimestampAdjuster timestampAdjuster, ExtractorOutput extractorOutput,
        TrackIdGenerator idGenerator) {
      // Do nothing.
    }

    @Override
    public void consume(ParsableByteArray sectionData) {
      int tableId = sectionData.readUnsignedByte();
      if (tableId != 0x00 /* program_association_section */) {
        // See ISO/IEC 13818-1, section 2.4.4.4 for more information on table id assignment.
        return;
      }
      // section_syntax_indicator(1), '0'(1), reserved(2), section_length(12),
      // transport_stream_id (16), reserved (2), version_number (5), current_next_indicator (1),
      // section_number (8), last_section_number (8)
      sectionData.skipBytes(7);

      int programCount = sectionData.bytesLeft() / 4;
      for (int i = 0; i < programCount; i++) {
        sectionData.readBytes(patScratch, 4);
        int programNumber = patScratch.readBits(16);
        patScratch.skipBits(3); // reserved (3)
        if (programNumber == 0) {
          patScratch.skipBits(13); // network_PID (13)
        } else {
          int pid = patScratch.readBits(13);
          tsPayloadReaders.put(pid, new SectionReader(new PmtReader(pid)));
          remainingPmts++;
        }
      }
      if (mode != MODE_HLS) {
        tsPayloadReaders.remove(TS_PAT_PID);
      }
    }

  }

  /**
   * Parses Program Map Table.
   */
  private class PmtReader implements SectionPayloadReader {

    private static final int TS_PMT_DESC_REGISTRATION = 0x05;
    private static final int TS_PMT_DESC_ISO639_LANG = 0x0A;
    private static final int TS_PMT_DESC_AC3 = 0x6A;
    private static final int TS_PMT_DESC_EAC3 = 0x7A;
    private static final int TS_PMT_DESC_DTS = 0x7B;
    private static final int TS_PMT_DESC_DVBSUBS = 0x59;

    private final ParsableBitArray pmtScratch;
    private final int pid;

    public PmtReader(int pid) {
      pmtScratch = new ParsableBitArray(new byte[5]);
      this.pid = pid;
    }

    @Override
    public void init(TimestampAdjuster timestampAdjuster, ExtractorOutput extractorOutput,
        TrackIdGenerator idGenerator) {
      // Do nothing.
    }

    @Override
    public void consume(ParsableByteArray sectionData) {
      int tableId = sectionData.readUnsignedByte();
      if (tableId != 0x02 /* TS_program_map_section */) {
        // See ISO/IEC 13818-1, section 2.4.4.4 for more information on table id assignment.
        return;
      }
      // TimestampAdjuster assignment.
      TimestampAdjuster timestampAdjuster;
      if (mode == MODE_SINGLE_PMT || mode == MODE_HLS || remainingPmts == 1) {
        timestampAdjuster = timestampAdjusters.get(0);
      } else {
        timestampAdjuster = new TimestampAdjuster(
            timestampAdjusters.get(0).getFirstSampleTimestampUs());
        timestampAdjusters.add(timestampAdjuster);
      }

      // section_syntax_indicator(1), '0'(1), reserved(2), section_length(12)
      sectionData.skipBytes(2);
      int programNumber = sectionData.readUnsignedShort();
      // reserved (2), version_number (5), current_next_indicator (1), section_number (8),
      // last_section_number (8), reserved (3), PCR_PID (13)
      sectionData.skipBytes(5);

      // Read program_info_length.
      sectionData.readBytes(pmtScratch, 2);
      pmtScratch.skipBits(4);
      int programInfoLength = pmtScratch.readBits(12);

      // Skip the descriptors.
      sectionData.skipBytes(programInfoLength);

      if (mode == MODE_HLS && id3Reader == null) {
        // Setup an ID3 track regardless of whether there's a corresponding entry, in case one
        // appears intermittently during playback. See [Internal: b/20261500].
        EsInfo dummyEsInfo = new EsInfo(TS_STREAM_TYPE_ID3, null, null, new byte[0]);
        id3Reader = payloadReaderFactory.createPayloadReader(TS_STREAM_TYPE_ID3, dummyEsInfo);
        id3Reader.init(timestampAdjuster, output,
            new TrackIdGenerator(programNumber, TS_STREAM_TYPE_ID3, MAX_PID_PLUS_ONE));
      }

      int remainingEntriesLength = sectionData.bytesLeft();
      while (remainingEntriesLength > 0) {
        sectionData.readBytes(pmtScratch, 5);
        int streamType = pmtScratch.readBits(8);
        pmtScratch.skipBits(3); // reserved
        int elementaryPid = pmtScratch.readBits(13);
        pmtScratch.skipBits(4); // reserved
        int esInfoLength = pmtScratch.readBits(12); // ES_info_length.
        EsInfo esInfo = readEsInfo(sectionData, esInfoLength);
        if (streamType == 0x06) {
          streamType = esInfo.streamType;
        }
        remainingEntriesLength -= esInfoLength + 5;

        int trackId = mode == MODE_HLS ? streamType : elementaryPid;
        if (trackIds.get(trackId)) {
          continue;
        }
        trackIds.put(trackId, true);

        TsPayloadReader reader;
        if (mode == MODE_HLS && streamType == TS_STREAM_TYPE_ID3) {
          reader = id3Reader;
        } else {
          reader = payloadReaderFactory.createPayloadReader(streamType, esInfo);
          if (reader != null) {
            reader.init(timestampAdjuster, output,
                new TrackIdGenerator(programNumber, trackId, MAX_PID_PLUS_ONE));
          }
        }

        if (reader != null) {
          tsPayloadReaders.put(elementaryPid, reader);
        }
      }
      if (mode == MODE_HLS) {
        if (!tracksEnded) {
          output.endTracks();
          remainingPmts = 0;
          tracksEnded = true;
        }
      } else {
        tsPayloadReaders.remove(pid);
        remainingPmts = mode == MODE_SINGLE_PMT ? 0 : remainingPmts - 1;
        if (remainingPmts == 0) {
          output.endTracks();
          tracksEnded = true;
        }
      }
    }

    /**
     * Returns the stream info read from the available descriptors. Sets {@code data}'s position to
     * the end of the descriptors.
     *
     * @param data A buffer with its position set to the start of the first descriptor.
     * @param length The length of descriptors to read from the current position in {@code data}.
     * @return The stream info read from the available descriptors.
     */
    private EsInfo readEsInfo(ParsableByteArray data, int length) {
      int descriptorsStartPosition = data.getPosition();
      int descriptorsEndPosition = descriptorsStartPosition + length;
      int streamType = -1;
      String language = null;
      List<DvbSubtitleInfo> dvbSubtitleInfos = null;
      while (data.getPosition() < descriptorsEndPosition) {
        int descriptorTag = data.readUnsignedByte();
        int descriptorLength = data.readUnsignedByte();
        int positionOfNextDescriptor = data.getPosition() + descriptorLength;
        if (descriptorTag == TS_PMT_DESC_REGISTRATION) { // registration_descriptor
          long formatIdentifier = data.readUnsignedInt();
          if (formatIdentifier == AC3_FORMAT_IDENTIFIER) {
            streamType = TS_STREAM_TYPE_AC3;
          } else if (formatIdentifier == E_AC3_FORMAT_IDENTIFIER) {
            streamType = TS_STREAM_TYPE_E_AC3;
          } else if (formatIdentifier == HEVC_FORMAT_IDENTIFIER) {
            streamType = TS_STREAM_TYPE_H265;
          }
        } else if (descriptorTag == TS_PMT_DESC_AC3) { // AC-3_descriptor in DVB (ETSI EN 300 468)
          streamType = TS_STREAM_TYPE_AC3;
        } else if (descriptorTag == TS_PMT_DESC_EAC3) { // enhanced_AC-3_descriptor
          streamType = TS_STREAM_TYPE_E_AC3;
        } else if (descriptorTag == TS_PMT_DESC_DTS) { // DTS_descriptor
          streamType = TS_STREAM_TYPE_DTS;
        } else if (descriptorTag == TS_PMT_DESC_ISO639_LANG) {
          language = data.readString(3).trim();
          // Audio type is ignored.
        } else if (descriptorTag == TS_PMT_DESC_DVBSUBS) {
          streamType = TS_STREAM_TYPE_DVBSUBS;
          dvbSubtitleInfos = new ArrayList<>();
          while (data.getPosition() < positionOfNextDescriptor) {
            String dvbLanguage = data.readString(3).trim();
            int dvbSubtitlingType = data.readUnsignedByte();
            byte[] initializationData = new byte[4];
            data.readBytes(initializationData, 0, 4);
            dvbSubtitleInfos.add(new DvbSubtitleInfo(dvbLanguage, dvbSubtitlingType,
                initializationData));
          }
        }
        // Skip unused bytes of current descriptor.
        data.skipBytes(positionOfNextDescriptor - data.getPosition());
      }
      data.setPosition(descriptorsEndPosition);
      return new EsInfo(streamType, language, dvbSubtitleInfos,
          Arrays.copyOfRange(data.data, descriptorsStartPosition, descriptorsEndPosition));
    }

  }


}
