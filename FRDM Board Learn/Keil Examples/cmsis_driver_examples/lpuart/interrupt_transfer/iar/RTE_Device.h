/*
 * Copyright (c) 2016, Freescale Semiconductor, Inc.
 * Copyright 2016-2017 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef __RTE_DEVICE_H
#define __RTE_DEVICE_H

/* USART Select. */
/* Use UART0 - UART2. */
#define RTE_USART0        0
#define RTE_USART0_DMA_EN 0
#define RTE_USART1        0
#define RTE_USART1_DMA_EN 0
#define RTE_USART2        0
#define RTE_USART2_DMA_EN 0
/*Use LPUART0. */
#define RTE_USART3        1
#define RTE_USART3_DMA_EN 0

/* UART RX Buffer configuration. */
#define USART_RX_BUFFER_LEN     64
#define USART0_RX_BUFFER_ENABLE 0
#define USART1_RX_BUFFER_ENABLE 0
#define USART2_RX_BUFFER_ENABLE 0
#define USART3_RX_BUFFER_ENABLE 1

/* UART configuration. */

#define RTE_USART0_DMA_TX_CH          0
#define RTE_USART0_DMA_TX_PERI_SEL    (uint8_t) kDmaRequestMux0UART0Tx
#define RTE_USART0_DMA_TX_DMAMUX_BASE DMAMUX0
#define RTE_USART0_DMA_TX_DMA_BASE    DMA0
#define RTE_USART0_DMA_RX_CH          1
#define RTE_USART0_DMA_RX_PERI_SEL    (uint8_t) kDmaRequestMux0UART0Rx
#define RTE_USART0_DMA_RX_DMAMUX_BASE DMAMUX0
#define RTE_USART0_DMA_RX_DMA_BASE    DMA0

#define RTE_USART1_DMA_TX_CH          0
#define RTE_USART1_DMA_TX_PERI_SEL    (uint8_t) kDmaRequestMux0UART1Tx
#define RTE_USART1_DMA_TX_DMAMUX_BASE DMAMUX0
#define RTE_USART1_DMA_TX_DMA_BASE    DMA0
#define RTE_USART1_DMA_RX_CH          1
#define RTE_USART1_DMA_RX_PERI_SEL    (uint8_t) kDmaRequestMux0UART1Rx
#define RTE_USART1_DMA_RX_DMAMUX_BASE DMAMUX0
#define RTE_USART1_DMA_RX_DMA_BASE    DMA0

#define RTE_USART2_DMA_TX_CH          0
#define RTE_USART2_DMA_TX_PERI_SEL    (uint8_t) kDmaRequestMux0UART2Tx
#define RTE_USART2_DMA_TX_DMAMUX_BASE DMAMUX0
#define RTE_USART2_DMA_TX_DMA_BASE    DMA0
#define RTE_USART2_DMA_RX_CH          1
#define RTE_USART2_DMA_RX_PERI_SEL    (uint8_t) kDmaRequestMux0UART2Rx
#define RTE_USART2_DMA_RX_DMAMUX_BASE DMAMUX0
#define RTE_USART2_DMA_RX_DMA_BASE    DMA0

#define RTE_USART3_DMA_TX_CH          0
#define RTE_USART3_DMA_TX_PERI_SEL    (uint8_t) kDmaRequestMux0LPUART0Tx
#define RTE_USART3_DMA_TX_DMAMUX_BASE DMAMUX0
#define RTE_USART3_DMA_TX_DMA_BASE    DMA0
#define RTE_USART3_DMA_RX_CH          1
#define RTE_USART3_DMA_RX_PERI_SEL    (uint8_t) kDmaRequestMux0LPUART0Rx
#define RTE_USART3_DMA_RX_DMAMUX_BASE DMAMUX0
#define RTE_USART3_DMA_RX_DMA_BASE    DMA0

#endif /* __RTE_DEVICE_H */
