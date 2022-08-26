"use strict";

const { Contract } = require("fabric-contract-api");

class PowerContract extends Contract {
    //Init function
    async InitGold() {
        console.log("Power contract has been started");
    }

    //Create New Consumer
    async CreateConsumer(ctx, args) {
        const data = JSON.parse(args);
        const consumerId = data.id;
        console.log("incoming asset fields= ", data);

        // Check if record already exits
        let queryString = {};
        queryString.selector = {};
        queryString.selector.docType = "Consumer";
        queryString.selector.id = consumerId;
        let duplicate = await this.GetQueryResultForQueryString(
            ctx,
            JSON.stringify(queryString)
        );
        let jsonResp = {};
        if (duplicate) {
            jsonResp.error = `Consumer already exist: ${id}`;
            throw new Error(jsonResp);
        }

        let consumer = {
            docType: "Consumer",
            id: consumerId,
            name: data.name,
            state: data.state,
            address: data.address,
            contactDetails: {
                type: data.contactDetails.type,
                contact: data.contactDetails.contact,
            },
            NMA: data.NMA,
            identification: {
                number: data.identification.number,
                type: data.identification.type,
                expiry: data.identification.expiry,
            },
            meter: {
                meterNo: data.meter.meterNo,
                meterChangeDate: data.meter.meterChangeDate,
                meterType: data.meter.meterType,
                simIP: data.meter.simIP,
                nicNo: data.meter.nicNo,
            },
            createdAt: ctx.stub.getDateTimestamp(),
            updatedAt: ctx.stub.getDateTimestamp(),
        };

        

        // === Save asset to state ===
        console.log(JSON.stringify(consumer));
        await ctx.stub.putState(
            consumerId,
            Buffer.from(JSON.stringify(consumer))
        );
        return consumer;
    }

    //Getter Functions
    async FindOne(ctx, query = {}, docType) {
        const queryData = JSON.parse(query);
        const queryString = {
            selector: {
                ...queryData,
                docType,
            },
        };
        const data = await this.GetQueryResultForQueryString(
            ctx,
            JSON.stringify(queryString)
        );
        const data1 = JSON.stringify(Array.from(new Int32Array(data)));
        return data1;
    }

    async GetQueryResultForQueryString(ctx, queryString) {
        let resultsIterator = await ctx.stub.getQueryResult(queryString);
        let results = await this.GetAllResults(resultsIterator, false);

        return JSON.stringify(results);
    }

    async GetAllResults(iterator, isHistory) {
        let allResults = [];
        let res = await iterator.next();
        while (!res.done) {
            if (res.value && res.value.value.toString()) {
                let jsonRes = {};
                console.log(res.value.value.toString("utf8"));
                if (isHistory && isHistory === true) {
                    jsonRes.TxId = res.value.tx_id;
                    jsonRes.Timestamp = res.value.timestamp;
                    try {
                        jsonRes.Value = JSON.parse(
                            res.value.value.toString("utf8")
                        );
                    } catch (err) {
                        console.log(err);
                        jsonRes.Value = res.value.value.toString("utf8");
                    }
                } else {
                    jsonRes = JSON.parse(res.value.value.toString("utf8"));
                    // jsonRes.Key = res.value.key;
                    // try {
                    // 	jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
                    // } catch (err) {
                    // 	console.log(err);
                    // 	jsonRes.Record = res.value.value.toString('utf8');
                    // }
                }
                allResults.push(jsonRes);
            }
            res = await iterator.next();
        }
        iterator.close();
        return allResults;
    }
}

module.exports = PowerContract;
