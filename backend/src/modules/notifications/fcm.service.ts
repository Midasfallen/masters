import { Injectable, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { Message, MulticastMessage } from 'firebase-admin/messaging';

/**
 * FCM/APNs Push Notification Service
 *
 * Handles sending push notifications via Firebase Cloud Messaging
 * Supports both Android (FCM) and iOS (APNs via FCM)
 *
 * Configuration via environment variables:
 * - FCM_PROJECT_ID: Firebase project ID
 * - FCM_PRIVATE_KEY: Firebase private key (base64 encoded)
 * - FCM_CLIENT_EMAIL: Firebase client email
 *
 * Usage:
 *
 * // Send to single device
 * await fcmService.sendToDevice(token, {
 *   title: 'New Booking',
 *   body: 'You have a new booking request',
 *   data: { bookingId: '123' }
 * });
 *
 * // Send to topic
 * await fcmService.sendToTopic('masters', {
 *   title: 'Platform Update',
 *   body: 'New features available'
 * });
 */

export interface PushNotificationPayload {
  title: string;
  body: string;
  data?: Record<string, string>;
  imageUrl?: string;
  clickAction?: string;
}

@Injectable()
export class FCMService {
  private readonly logger = new Logger(FCMService.name);
  private firebaseApp: admin.app.App | null = null;
  private isInitialized = false;

  constructor() {
    this.initializeFirebase();
  }

  /**
   * Initialize Firebase Admin SDK
   */
  private initializeFirebase(): void {
    try {
      const projectId = process.env.FCM_PROJECT_ID;
      const privateKey = process.env.FCM_PRIVATE_KEY
        ? Buffer.from(process.env.FCM_PRIVATE_KEY, 'base64').toString('utf-8')
        : undefined;
      const clientEmail = process.env.FCM_CLIENT_EMAIL;

      // Check if credentials are provided
      if (!projectId || !privateKey || !clientEmail) {
        this.logger.warn(
          '⚠️  FCM credentials not configured. Push notifications will be disabled.',
        );
        this.logger.warn(
          'Set FCM_PROJECT_ID, FCM_PRIVATE_KEY (base64), and FCM_CLIENT_EMAIL environment variables.',
        );
        return;
      }

      // Initialize Firebase Admin
      this.firebaseApp = admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          privateKey,
          clientEmail,
        }),
      });

      this.isInitialized = true;
      this.logger.log('✅ Firebase Cloud Messaging initialized successfully');
    } catch (error) {
      this.logger.error('❌ Failed to initialize Firebase Admin SDK:', error);
      this.isInitialized = false;
    }
  }

  /**
   * Send push notification to a single device
   *
   * @param token - FCM device token
   * @param payload - Notification payload
   * @returns Message ID if successful
   */
  async sendToDevice(
    token: string,
    payload: PushNotificationPayload,
  ): Promise<string | null> {
    if (!this.isInitialized || !this.firebaseApp) {
      this.logger.warn('FCM not initialized. Skipping notification.');
      return null;
    }

    try {
      const message: Message = {
        token,
        notification: {
          title: payload.title,
          body: payload.body,
          imageUrl: payload.imageUrl,
        },
        data: payload.data,
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
            clickAction: payload.clickAction || 'FLUTTER_NOTIFICATION_CLICK',
            channelId: 'service_platform_notifications',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
              contentAvailable: true,
            },
          },
          headers: {
            'apns-priority': '10',
          },
        },
      };

      const response = await admin.messaging().send(message);
      this.logger.log(`✅ Notification sent successfully: ${response}`);
      return response;
    } catch (error) {
      this.logger.error('❌ Failed to send notification:', error);

      // Handle invalid token
      if (
        error.code === 'messaging/invalid-registration-token' ||
        error.code === 'messaging/registration-token-not-registered'
      ) {
        this.logger.warn(`Invalid or expired token: ${token}`);
        // TODO: Remove token from database
      }

      return null;
    }
  }

  /**
   * Send push notification to multiple devices
   *
   * @param tokens - Array of FCM device tokens
   * @param payload - Notification payload
   * @returns Number of successfully sent notifications
   */
  async sendToMultipleDevices(
    tokens: string[],
    payload: PushNotificationPayload,
  ): Promise<number> {
    if (!this.isInitialized || !this.firebaseApp) {
      this.logger.warn('FCM not initialized. Skipping notifications.');
      return 0;
    }

    if (tokens.length === 0) {
      this.logger.warn('No tokens provided for multicast notification.');
      return 0;
    }

    try {
      const message: MulticastMessage = {
        tokens,
        notification: {
          title: payload.title,
          body: payload.body,
          imageUrl: payload.imageUrl,
        },
        data: payload.data,
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
            clickAction: payload.clickAction || 'FLUTTER_NOTIFICATION_CLICK',
            channelId: 'service_platform_notifications',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
              contentAvailable: true,
            },
          },
          headers: {
            'apns-priority': '10',
          },
        },
      };

      const response = await admin.messaging().sendEachForMulticast(message);

      this.logger.log(
        `✅ Multicast notification sent: ${response.successCount}/${tokens.length} successful`,
      );

      // Log failed tokens
      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            this.logger.warn(`Failed to send to token ${tokens[idx]}: ${resp.error?.message}`);
          }
        });
      }

      return response.successCount;
    } catch (error) {
      this.logger.error('❌ Failed to send multicast notification:', error);
      return 0;
    }
  }

  /**
   * Send push notification to a topic
   *
   * @param topic - Topic name (e.g., 'all_users', 'masters', 'clients')
   * @param payload - Notification payload
   * @returns Message ID if successful
   */
  async sendToTopic(
    topic: string,
    payload: PushNotificationPayload,
  ): Promise<string | null> {
    if (!this.isInitialized || !this.firebaseApp) {
      this.logger.warn('FCM not initialized. Skipping notification.');
      return null;
    }

    try {
      const message: Message = {
        topic,
        notification: {
          title: payload.title,
          body: payload.body,
          imageUrl: payload.imageUrl,
        },
        data: payload.data,
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
            clickAction: payload.clickAction || 'FLUTTER_NOTIFICATION_CLICK',
            channelId: 'service_platform_notifications',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
              contentAvailable: true,
            },
          },
          headers: {
            'apns-priority': '10',
          },
        },
      };

      const response = await admin.messaging().send(message);
      this.logger.log(`✅ Topic notification sent to '${topic}': ${response}`);
      return response;
    } catch (error) {
      this.logger.error(`❌ Failed to send topic notification to '${topic}':`, error);
      return null;
    }
  }

  /**
   * Subscribe device token to a topic
   *
   * @param tokens - Device token(s) to subscribe
   * @param topic - Topic name
   * @returns True if successful
   */
  async subscribeToTopic(tokens: string | string[], topic: string): Promise<boolean> {
    if (!this.isInitialized || !this.firebaseApp) {
      this.logger.warn('FCM not initialized. Cannot subscribe to topic.');
      return false;
    }

    try {
      const tokenArray = Array.isArray(tokens) ? tokens : [tokens];
      const response = await admin.messaging().subscribeToTopic(tokenArray, topic);

      this.logger.log(
        `✅ Subscribed ${response.successCount}/${tokenArray.length} tokens to topic '${topic}'`,
      );

      if (response.failureCount > 0) {
        this.logger.warn(
          `Failed to subscribe ${response.failureCount} tokens to topic '${topic}'`,
        );
      }

      return response.successCount > 0;
    } catch (error) {
      this.logger.error(`❌ Failed to subscribe to topic '${topic}':`, error);
      return false;
    }
  }

  /**
   * Unsubscribe device token from a topic
   *
   * @param tokens - Device token(s) to unsubscribe
   * @param topic - Topic name
   * @returns True if successful
   */
  async unsubscribeFromTopic(tokens: string | string[], topic: string): Promise<boolean> {
    if (!this.isInitialized || !this.firebaseApp) {
      this.logger.warn('FCM not initialized. Cannot unsubscribe from topic.');
      return false;
    }

    try {
      const tokenArray = Array.isArray(tokens) ? tokens : [tokens];
      const response = await admin.messaging().unsubscribeFromTopic(tokenArray, topic);

      this.logger.log(
        `✅ Unsubscribed ${response.successCount}/${tokenArray.length} tokens from topic '${topic}'`,
      );

      if (response.failureCount > 0) {
        this.logger.warn(
          `Failed to unsubscribe ${response.failureCount} tokens from topic '${topic}'`,
        );
      }

      return response.successCount > 0;
    } catch (error) {
      this.logger.error(`❌ Failed to unsubscribe from topic '${topic}':`, error);
      return false;
    }
  }

  /**
   * Send data-only message (silent notification)
   * Useful for triggering app updates without showing a notification
   *
   * @param token - FCM device token
   * @param data - Data payload
   * @returns Message ID if successful
   */
  async sendDataMessage(token: string, data: Record<string, string>): Promise<string | null> {
    if (!this.isInitialized || !this.firebaseApp) {
      this.logger.warn('FCM not initialized. Skipping data message.');
      return null;
    }

    try {
      const message: Message = {
        token,
        data,
        android: {
          priority: 'high',
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
            },
          },
          headers: {
            'apns-push-type': 'background',
            'apns-priority': '5',
          },
        },
      };

      const response = await admin.messaging().send(message);
      this.logger.log(`✅ Data message sent successfully: ${response}`);
      return response;
    } catch (error) {
      this.logger.error('❌ Failed to send data message:', error);
      return null;
    }
  }

  /**
   * Check if FCM is properly initialized
   */
  isReady(): boolean {
    return this.isInitialized;
  }
}
