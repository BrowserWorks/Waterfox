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
package com.google.android.exoplayer2.upstream;

import android.net.Uri;
import com.google.android.exoplayer2.C;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.MulticastSocket;
import java.net.SocketException;

/**
 * A UDP {@link DataSource}.
 */
public final class UdpDataSource implements DataSource {

  /**
   * Thrown when an error is encountered when trying to read from a {@link UdpDataSource}.
   */
  public static final class UdpDataSourceException extends IOException {

    public UdpDataSourceException(IOException cause) {
      super(cause);
    }

  }

  /**
   * The default maximum datagram packet size, in bytes.
   */
  public static final int DEFAULT_MAX_PACKET_SIZE = 2000;

  /**
   * The default socket timeout, in milliseconds.
   */
  public static final int DEAFULT_SOCKET_TIMEOUT_MILLIS = 8 * 1000;

  private final TransferListener<? super UdpDataSource> listener;
  private final int socketTimeoutMillis;
  private final byte[] packetBuffer;
  private final DatagramPacket packet;

  private Uri uri;
  private DatagramSocket socket;
  private MulticastSocket multicastSocket;
  private InetAddress address;
  private InetSocketAddress socketAddress;
  private boolean opened;

  private int packetRemaining;

  /**
   * @param listener An optional listener.
   */
  public UdpDataSource(TransferListener<? super UdpDataSource> listener) {
    this(listener, DEFAULT_MAX_PACKET_SIZE);
  }

  /**
   * @param listener An optional listener.
   * @param maxPacketSize The maximum datagram packet size, in bytes.
   */
  public UdpDataSource(TransferListener<? super UdpDataSource> listener, int maxPacketSize) {
    this(listener, maxPacketSize, DEAFULT_SOCKET_TIMEOUT_MILLIS);
  }

  /**
   * @param listener An optional listener.
   * @param maxPacketSize The maximum datagram packet size, in bytes.
   * @param socketTimeoutMillis The socket timeout in milliseconds. A timeout of zero is interpreted
   *     as an infinite timeout.
   */
  public UdpDataSource(TransferListener<? super UdpDataSource> listener, int maxPacketSize,
      int socketTimeoutMillis) {
    this.listener = listener;
    this.socketTimeoutMillis = socketTimeoutMillis;
    packetBuffer = new byte[maxPacketSize];
    packet = new DatagramPacket(packetBuffer, 0, maxPacketSize);
  }

  @Override
  public long open(DataSpec dataSpec) throws UdpDataSourceException {
    uri = dataSpec.uri;
    String host = uri.getHost();
    int port = uri.getPort();

    try {
      address = InetAddress.getByName(host);
      socketAddress = new InetSocketAddress(address, port);
      if (address.isMulticastAddress()) {
        multicastSocket = new MulticastSocket(socketAddress);
        multicastSocket.joinGroup(address);
        socket = multicastSocket;
      } else {
        socket = new DatagramSocket(socketAddress);
      }
    } catch (IOException e) {
      throw new UdpDataSourceException(e);
    }

    try {
      socket.setSoTimeout(socketTimeoutMillis);
    } catch (SocketException e) {
      throw new UdpDataSourceException(e);
    }

    opened = true;
    if (listener != null) {
      listener.onTransferStart(this, dataSpec);
    }
    return C.LENGTH_UNSET;
  }

  @Override
  public int read(byte[] buffer, int offset, int readLength) throws UdpDataSourceException {
    if (readLength == 0) {
      return 0;
    }

    if (packetRemaining == 0) {
      // We've read all of the data from the current packet. Get another.
      try {
        socket.receive(packet);
      } catch (IOException e) {
        throw new UdpDataSourceException(e);
      }
      packetRemaining = packet.getLength();
      if (listener != null) {
        listener.onBytesTransferred(this, packetRemaining);
      }
    }

    int packetOffset = packet.getLength() - packetRemaining;
    int bytesToRead = Math.min(packetRemaining, readLength);
    System.arraycopy(packetBuffer, packetOffset, buffer, offset, bytesToRead);
    packetRemaining -= bytesToRead;
    return bytesToRead;
  }

  @Override
  public Uri getUri() {
    return uri;
  }

  @Override
  public void close() {
    uri = null;
    if (multicastSocket != null) {
      try {
        multicastSocket.leaveGroup(address);
      } catch (IOException e) {
        // Do nothing.
      }
      multicastSocket = null;
    }
    if (socket != null) {
      socket.close();
      socket = null;
    }
    address = null;
    socketAddress = null;
    packetRemaining = 0;
    if (opened) {
      opened = false;
      if (listener != null) {
        listener.onTransferEnd(this);
      }
    }
  }

}
